require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:email){ "abc@example.com" }
  let(:password) { "abcd1234" }
  describe "POST /register" do
    before do
      allow(RegisterMailer).to receive_message_chain(:register, :deliver_now)
    end

    let(:params) do
      {
        "name": "name",
        "email": email,
        "password": password,
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
  end

  describe "GET /users/{id}" do
    let!(:user) { create(:user) }
    it "他ユーザーの情報が取得できること" do
      authenticate_stub(user)
      get api_user_path(id: user.id), headers: headers
      expect(response).to have_http_status(200)
      expect(json_response["token"]).to be nil
      expect(json_response["id"]).to eq(user.id)
      expect(json_response["name"]).to eq(user.name)
      expect(json_response["email"]).to eq(user.email)
      expect(json_response["register_status"]).to eq(user.register_status)
    end
  end
end
