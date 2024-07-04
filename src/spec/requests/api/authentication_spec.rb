require 'rails_helper'

RSpec.describe "Authentications", type: :request do
  let(:user) { create(:user) }
  let(:params) do
    {
      email: user.email,
      password: user.password
    }
  end

  describe "POST /login" do
    it "ログインできること" do
      post api_login_path, params: params, headers: headers
      expect(response).to have_http_status(200)
    end

    let(:uncorrect_params) do
      {
        email: user.email,
        password: SecureRandom.alphanumeric(10)
      }
    end
    context "パスワードが違っているとき" do
      it "ログインに失敗すること" do
        post api_login_path, params: uncorrect_params, headers: headers
        expect(response).to have_http_status(401)
      end
    end
  end
end
