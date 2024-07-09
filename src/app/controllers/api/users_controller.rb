class Api::UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[update]

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

    render json: user, serializer: UserSerializer
  end

  def update
    current_user.update!(name: params["name"])

    render json: current_user, serializer: UserSerializer
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end

  def send_email(user)
    RegisterMailer.register(user, user.email).deliver_now
  end
end
