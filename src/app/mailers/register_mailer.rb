class RegisterMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def register(user, address)
    @user = user
    @url  = "#{ENV["BACKEND_BASE_URL"]}/api/authentication?token=#{@user.register_token}"
    mail(to: address, subject: "会員登録のお知らせ")
  end
end
