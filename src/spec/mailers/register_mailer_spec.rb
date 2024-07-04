require "rails_helper"

RSpec.describe RegisterMailer, type: :mailer do
  let(:user) { build(:user) }
  let(:address) { user.email }
  describe "会員登録のメール送信" do
    let(:mail) { RegisterMailer.register(user, address) }
    before do
      user.generate_register_token
      mail.deliver_now
    end
    context "メールを送信したとき" do
      it "ヘッダー情報,ボディ情報が正しいこと" do
        expect(mail.subject).to eq "会員登録のお知らせ"
        expect(mail.to).to eq [address]
        expect(mail.from).to eq ['notifications@example.com']
      end
    end
  end
end
