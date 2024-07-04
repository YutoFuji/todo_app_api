require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "POST /register" do
    let(:email){ "abc@example.com" }
    before do
      allow(RegisterMailer).to receive_message_chain(:register, :deliver_now)
    end

    let(:params) do
      {
        "name": "name",
        "email": email,
        "password": "password",
        "password_confirm": "password"
      }
    end
    it "新規会員登録メールが送信されること" do
      post api_register_path, params: params, headers: headers
      expect(response).to have_http_status(200)
      expect(RegisterMailer.register).to have_received(:deliver_now).once
    end
    it "登録状況が更新されていること" do
      expect do
        post api_register_path, params: params, headers: headers
      end.to change { User.find_by(email: email)&.register_status }.from(nil).to("incomplete")
    end
    context "確認パスワードが異なっているとき" do
      let(:invalid_params) do
        {
          "name": "name",
          "email": email,
          "password": "password",
          "password_confirm": "different_password"
        }
      end
      it "エラーが返されること" do
        post api_register_path, params: invalid_params, headers: headers
        expect(response).to have_http_status(400)
      end
    end
  end

  describe "GET /register_completion" do
    let(:reset_token) { SecureRandom.alphanumeric(10) }
    let(:user) { create(:user, register_token: reset_token, register_token_sent_at: (Time.zone.now - 10.minutes)) }
    let(:params) do
      {
        "token": reset_token
      }
    end
    it "登録状況が更新されていること" do
      expect do
        get api_register_completion_path, params: params, headers: headers
      end.to change { User.find(user.id)&.register_status }.from("incomplete").to("complete")
    end
    context "トークンが異なっているとき" do
      let(:invalid_token) { SecureRandom.alphanumeric(10) }
      let(:invalid_params) do
        {
          "token": invalid_token
        }
      end
      it "エラーが返ること" do
        get api_register_completion_path, params: params, headers: headers
        expect(response).to have_http_status(400)
      end
    end
  end

  describe "PUT /users/{user_id}" do
    let!(:user) { create(:user) }
    let(:params) do
      {
        "name": "changed_name"
      }
    end
    it "名前を変更できること" do
      authenticate_stub(user)
      expect do
        put api_user_path(id: user.id), params: params, headers: headers
      end.to change { user.reload.name }.from("testuser1").to("changed_name")
    end
    it "データが増えていないこと" do
      authenticate_stub(user)
      users = User.all
      expect do
        put api_user_path(id: user.id), params: params, headers: headers
      end.not_to change { users.size }.from(1)
    end
  end

  describe "PUT /users/{user_id}/password_update" do
    let!(:user) { create(:user) }
    let(:params) do
      {
        "current_password": "password",
        "password": "new_password",
        "password_confirm": "new_password"
      }
    end
    it "パスワードを変更できること" do
      authenticate_stub(user)
      expect do
        put api_user_password_update_path(user_id: user.id), params: params, headers: headers
      end.to change { user.reload.password }.from("password").to("new_password")
    end
    context "確認パスワードが異なっていたとき" do
      let(:invalid_params) do
        {
          "current_password": "password",
          "password": "new_password",
          "password_confirm": "different_password"
        }
      end
      it "エラーが起こること" do
        authenticate_stub(user)
        put api_user_password_update_path(user_id: user.id), params: invalid_params, headers: headers
        expect(response).to have_http_status(400)
      end
    end
    context "入力された現在のパスワードが異なっていたとき" do
      let(:invalid_params) do
        {
          "current_password": "different_password",
          "password": "new_password",
          "password_confirm": "new_password"
        }
      end
      it "エラーが起こること" do
        authenticate_stub(user)
        put api_user_password_update_path(user_id: user.id), params: invalid_params, headers: headers
        expect(response).to have_http_status(400)
      end
    end
  end
end
