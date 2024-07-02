class Api::UsersController < ApplicationController

  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created
    else
      # TODO: エラーハンドリングまとめて適用
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end

end
