class Api::AuthenticationsController < ApplicationController
  def create
    @user = User.find_by!(email: params[:email])
    raise ServerError::BadRequest if @user.incomplete?

    if @user&.authenticate(params[:password])
      token = create_token(@user.id)
      render json: { "token": token }.merge(@user.as_json)
    else
      raise ServerError::BadRequest
    end
  end

  def show
    user = User.find_by!(register_token: params["token"])

    unless user.register_token_valid?
      raise ActionController::BadRequest
    end
    user.complete!
    user.remove_register_token

    # TODO: パラメータをつける（フロントで出しわけするため）
    login_url = "#{ENV["FRONTEND_BASE_URL"]}/login"

    redirect_to login_url
  end
end
