class Api::Password::PasswordsController < ApplicationController
  before_action :authenticate_user!, only: [:forgot]

  def forgot
    if current_user.email
      handle_reset_token(current_user)
      render status: :ok
    else
      render status: :not_found
    end
  end

  def create_by_email
    user = User.find_by!(email: params["email"])
    handle_reset_token(user)
    render status: :ok
  end

  def reset
    user = User.find_by!(password_reset_token: params["token"])
    if user.password_reset_token_valid?
      user.reset_password(params["password"])
    end

    render status: :ok
  end

  private

  def handle_reset_token(user)
    ActiveRecord::Base.transaction do
      user.generate_password_reset_token
      send_email(user)
    end
  end

  def send_email(user)
    PasswordResetMailer.password_reset(user, user.email).deliver_now
  end
end
