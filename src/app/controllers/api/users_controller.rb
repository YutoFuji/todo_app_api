class Api::UsersController < ApplicationController
  before_action :authenticate_user!, only: [:update, :update_password]

  def create
    unless password_confirm_same?
      raise ActionController::BadRequest
    end

    user = User.new(user_params)
    user.incomplete!

    ActiveRecord::Base.transaction do
      user.save!
      user.generate_register_token
      send_email(user)
    end

    render json: user, status: :ok
  end

  def email_confirm
    user = User.find_by(register_token: params["token"])

    unless user && user.register_token_valid?
      raise ActionController::BadRequest
    end
    user.complete!

    render json: user, status: :ok
  end

  def update
    current_user.update!(name: params["name"])

    render json: current_user
  end

  def update_password
    unless password_valid?
      raise ActionController::BadRequest
    end

    current_user.update!(password: params["password"])

    render json: current_user
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end

  def send_email(user)
    RegisterMailer.register(user, user.email).deliver_now
  end

  def password_valid?
    password_confirm_same? && current_password_valid?
  end

  def password_confirm_same?
    params["password"] == params["password_confirm"]
  end

  def current_password_valid?
    current_user.current_password?(params["current_password"])
  end
end
