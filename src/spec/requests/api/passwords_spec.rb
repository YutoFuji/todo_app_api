require 'rails_helper'

RSpec.describe "Passwords", type: :request do
  let(:user) { create(:user) }
  before do
    allow(PasswordResetMailer).to receive_message_chain(:password_reset, :deliver_now)
  end

  describe "POST /users/{user_id}/password/forgot" do
    it "正常にメールが送信されていること" do
      authenticate_stub(user)
      post api_user_password_forgot_path(user_id: user.id), headers: headers
      expect(response).to have_http_status(200)
      expect(PasswordResetMailer.password_reset).to have_received(:deliver_now).once
    end
  end

  describe "POST /users/{user_id}/password/reset" do
    let(:reset_token) { SecureRandom.alphanumeric(10) }
    let(:user) { create(:user, password_reset_token: reset_token, password_reset_token_sent_at: (Time.zone.now - 10.minutes)) }
    let(:params) do
      {
        "token": reset_token,
        "password": "new_password"
      }
    end
    it "処理できること" do
      post api_user_password_reset_path(user_id: user.id), params: params, headers: headers
      expect(response).to have_http_status(200)
    end
    context "リセットトークンが異なっていたとき" do
      let(:invalid_token) { SecureRandom.alphanumeric(10) }
      let(:invalid_params) do
        {
          "token": invalid_token,
          "password": "new_password"
        }
      end
      it "エラーになること" do
        post api_user_password_reset_path(user_id: user.id), params: invalid_params, headers: headers
        expect(response).to have_http_status(400)
      end
    end
  end
end
