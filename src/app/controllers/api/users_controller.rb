class Api::UsersController < ApplicationController
  before_action :authenticate_user!, only: [:update, :update_password]

  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created
    else
      # TODO: エラーハンドリングまとめて適用
      render status: :unprocessable_entity
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

  def password_valid?
    params["password"] == params["password_confirm"] && current_user.current_password?(params["current_password"])
  end
end
