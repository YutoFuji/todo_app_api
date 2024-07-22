class Api::UsersController < ApplicationController
  def create
    user = User.new(user_params)
    user.incomplete!

    ActiveRecord::Base.transaction do
      user.save!
      user.generate_register_token
      send_email(user)
    end

    render json: user, serializer: UserSerializer
  end

  def show
    user = User.find(params["id"])

    render json: user, serializer: UserSerializer
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end

  def send_email(user)
    RegisterMailer.register(user, user.email).deliver_now
  end
end
