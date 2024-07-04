class RegisterMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def register(user, address)
    @user = user
    @url  = "http://localhost:8888/api/register_completion?token=#{@user.register_token}"
    mail(to: address, subject: "会員登録のお知らせ")
  end
end
