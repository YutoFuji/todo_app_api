require 'rails_helper'

RSpec.describe "Password::Forgots", type: :request do
  let(:user) { create(:user) }
  before do
    allow(PasswordResetMailer).to receive_message_chain(:password_reset, :deliver_now)
  end

  describe "POST /password/forgot" do
    it "正常にメールが送信されていること" do
      authenticate_stub(user)
      post api_password_forgot_path(user_id: user.id), headers: headers
      expect(response).to have_http_status(200)
      expect(PasswordResetMailer.password_reset).to have_received(:deliver_now).once
    end
  end
end
