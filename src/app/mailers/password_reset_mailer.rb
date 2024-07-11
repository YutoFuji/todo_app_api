class PasswordResetMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def password_reset(user, address)
    @user = user
    @url  = "http://localhost:3000/login?token?token=#{@user.password_reset_token}"
    mail(to: address, subject: "パスワード変更を承りました")
  end
end
