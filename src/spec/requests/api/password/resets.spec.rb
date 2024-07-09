require 'rails_helper'

RSpec.describe "Password::Resets", type: :request do
  let(:user) { create(:user) }
  before do
    allow(PasswordResetMailer).to receive_message_chain(:password_reset, :deliver_now)
  end

  describe "POST /password/reset" do
    let(:params) do
      {
        "email": user.email
      }
    end
    it "正常にメールが送信されていること" do
      post api_password_reset_path, params: params, headers: headers
      expect(response).to have_http_status(200)
      expect(PasswordResetMailer.password_reset).to have_received(:deliver_now).once
    end
    context "メールアドレスが登録されていなかったとき" do
      let(:invalid_email) { "wxyz@example.com" }
      let(:invalid_params) do
        {
          "email": invalid_email
        }
      end
      it "エラーが返ること" do
        post api_password_reset_path, params: invalid_params, headers: headers
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "PUT /password/reset" do
    let(:reset_token) { SecureRandom.alphanumeric(10) }
    let(:new_password) { "vwxz9876" }
    let(:user) { create(:user, password_reset_token: reset_token, password_reset_token_sent_at: (Time.zone.now - 10.minutes)) }
    let(:params) do
      {
        "token": reset_token,
        "password": new_password
      }
    end
    it "処理できること" do
      put api_password_reset_path, params: params, headers: headers
      expect(response).to have_http_status(200)
    end
    context "リセットトークンが異なっていたとき" do
      let(:invalid_token) { SecureRandom.alphanumeric(10) }
      let(:invalid_params) do
        {
          "token": invalid_token,
          "password": new_password
        }
      end
      it "エラーになること" do
        put api_password_reset_path, params: invalid_params, headers: headers
        expect(response).to have_http_status(404)
      end
    end
  end
end
