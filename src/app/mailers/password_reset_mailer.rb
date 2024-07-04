class PasswordResetMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def password_reset(user, address)
    @user = user
    @url  = "http://localhost:8888/api/users/#{@user.id}/password/reset?token=#{@user.password_reset_token}"
    mail(to: address, subject: "パスワード変更を承りました")
  end
end
