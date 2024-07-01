class Api::AuthenticationController < ApplicationController
  def login
    @user = User.find_by(name: params[:name])
    if @user&.authenticate(params[:password])
      token = create_token(@user.id)
      render json: { user: @user, token: token }
    else
      render status: :unauthorized
    end
  end
end
