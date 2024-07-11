require 'rails_helper'

RSpec.describe "Passwords", type: :request do
  let(:user) { create(:user) }
  before do
    allow(PasswordResetMailer).to receive_message_chain(:password_reset, :deliver_now)
  end

  describe "POST /profile/password" do
    it "正常にメールが送信されていること" do
      authenticate_stub(user)
      post api_profile_password_path, headers: headers
      expect(response).to have_http_status(200)
      expect(PasswordResetMailer.password_reset).to have_received(:deliver_now).once
    end
  end

  describe "PUT /profile/password" do
    let!(:user) { create(:user) }
    let(:new_password) { "wxyz9876" }
    let(:params) do
      {
        "current_password": user.password,
        "password": new_password,
        "password_confirm": new_password
      }
    end
    it "パスワードを変更できること" do
      authenticate_stub(user)
      expect do
        put api_profile_password_path, params: params, headers: headers
      end.to change { user.reload.password }.from(user.password).to(new_password)
    end
    context "確認パスワードが異なっていたとき" do
      let(:invalid_params) do
        {
          "current_password": user.password,
          "password": new_password,
          "password_confirm": "vwxy9876"
        }
      end
      it "エラーが起こること" do
        authenticate_stub(user)
        put api_profile_password_path, params: invalid_params, headers: headers
        expect(response).to have_http_status(400)
      end
    end
    context "入力された現在のパスワードが異なっていたとき" do
      let(:invalid_params) do
        {
          "current_password": "bcdf2345",
          "password": new_password,
          "password_confirm": new_password
        }
      end
      it "エラーが起こること" do
        authenticate_stub(user)
        put api_profile_password_path, params: invalid_params, headers: headers
        expect(response).to have_http_status(400)
      end
    end
  end
end
