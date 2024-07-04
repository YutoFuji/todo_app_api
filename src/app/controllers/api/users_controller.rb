class Api::UsersController < ApplicationController
  before_action :authenticate_user!, only: [:update, :update_password]

  def create
    unless password_confirm_same?
      render status: :bad_request
      return
    end

    @user = User.new(user_params)
    @user.incomplete!

    if @user.save
      ActiveRecord::Base.transaction do
        @user.generate_register_token
        send_email(@user)
      end
      render json: @user, status: :ok
    else
      # TODO: エラーハンドリングまとめて適用
      render status: :unprocessable_entity
    end
  end

  def email_confirm
    user = User.find_by(register_token: params["token"])
    if user && user.register_token_valid?
      user.complete!
      render status: :ok
    else
      render status: :bad_request
    end
  end

  def update
    if current_user.update(name: params["name"])
      render status: :ok
    else
      render status: :bad_request
    end
  end

  def update_password
    unless password_valid?
      render status: :bad_request
      return
    end

    if current_user.update!(password: params["password"])
      render status: :ok
    else
      render status: :bad_request
    end
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
