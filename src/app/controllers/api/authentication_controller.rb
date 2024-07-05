class Api::AuthenticationController < ApplicationController
  def login
    @user = User.find_by(email: params[:email])
    raise ServerError::BadRequest if @user.incomplete?

    if @user&.authenticate(params[:password])
      token = create_token(@user.id)
      render json: { "token": token }
    else
      raise ServerError::BadRequest
    end
  end
end
