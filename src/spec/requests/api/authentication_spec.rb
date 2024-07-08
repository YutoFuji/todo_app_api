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
    it "トークンが返ってくること" do
      post api_login_path, params: params, headers: headers
      expect(response).to have_http_status(200)
      expect(json_response["token"]).to be_present
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
end
