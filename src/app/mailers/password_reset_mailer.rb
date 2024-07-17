class PasswordResetMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def password_reset(user, address)
    @user = user
    @url  = "#{ENV["BACKEND_BASE_URL"]}/login?token=#{@user.password_reset_token}"
    mail(to: address, subject: "パスワード変更を承りました")
  end
end
