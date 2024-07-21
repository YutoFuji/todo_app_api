require 'rails_helper'

RSpec.describe "Authentications", type: :request do
  describe "POST /login" do
    let(:user) { create(:user, register_status: "complete") }
    let(:params) do
      {
        email: user.email,
        password: user.password
      }
    end
    it "トークンとユーザー情報が返ってくること" do
      post api_login_path, params: params, headers: headers
      expect(response).to have_http_status(200)
      expect(json_response["token"]).to be_present
      expect(json_response["id"]).to eq(user.id)
      expect(json_response["name"]).to eq(user.name)
      expect(json_response["email"]).to eq(user.email)
      expect(json_response["register_status"]).to eq(user.register_status)
    end
    context "パスワードが違っているとき" do
      let(:uncorrect_password) { SecureRandom.alphanumeric(10) }
      let(:uncorrect_params) do
        {
          email: user.email,
          password: uncorrect_password
        }
      end
      it "ログインに失敗すること" do
        post api_login_path, params: uncorrect_params, headers: headers
        expect(response).to have_http_status(400)
      end
    end

    context "メール認証ができていないとき" do
      let(:user) { create(:user) }
      let(:params) do
        {
          email: user.email,
          password: user.password,
        }
      end
      it "ログインに失敗すること" do
        post api_login_path, params: params, headers: headers
        expect(response).to have_http_status(400)
      end
    end
  end

  describe "GET /authentication" do
    let(:reset_token) { SecureRandom.alphanumeric(10) }
    let(:user) { create(:user, register_token: reset_token, register_token_sent_at: (Time.zone.now - 10.minutes)) }
    let(:params) do
      {
        "token": reset_token
      }
    end
    it "登録状況が更新されていること" do
      expect do
        get api_authentication_path, params: params, headers: headers
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
        get api_authentication_path, params: params, headers: headers
        expect(response).to have_http_status(404)
      end
    end
  end
end
