require "rails_helper"

RSpec.describe PasswordResetMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:address) { user.email }
  describe "パスワードリセットのメール送信" do
    let(:mail) { PasswordResetMailer.password_reset(user, address) }
    before do
      user.generate_password_reset_token
      mail.deliver_now
    end
    context "メールを送信したとき" do
      it "ヘッダー情報,ボディ情報が正しいこと" do
        expect(mail.subject).to eq "パスワード変更を承りました"
        expect(mail.to).to eq [address]
        expect(mail.from).to eq ['notifications@example.com']
      end
    end
  end
end
