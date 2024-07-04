class Api::Password::PasswordsController < ApplicationController
  before_action :authenticate_user!, only: [:forgot]

  def forgot
    if current_user.email
      ActiveRecord::Base.transaction do
        current_user.generate_password_reset_token
        send_email(current_user)
      end
      render status: :ok
    else
      render status: :not_found
    end
  end

  def reset
    user = User.find_by(password_reset_token: params["token"])
    if user && user.password_reset_token_valid?
      user.reset_password(params["password"])
      render status: :ok
    else
      render status: :bad_request
    end
  end

  private

  def send_email(user)
    PasswordResetMailer.password_reset(user, user.email).deliver_now
  end
end
