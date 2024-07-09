class Api::PasswordsController < ApplicationController
  before_action :authenticate_user!, only: %i[create update]

  def create
    if current_user.email
      handle_reset_token(current_user)
      render status: :ok
    else
      render status: :not_found
    end
  end

  def update
    unless password_valid?
      raise ActionController::BadRequest
    end

    current_user.update!(password: params["password"])

    render json: current_user, serializer: UserSerializer
  end

  private

  def current_password_valid?
    current_user.current_password?(params["current_password"])
  end

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
