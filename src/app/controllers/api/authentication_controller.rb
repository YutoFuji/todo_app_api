class Api::AuthenticationController < ApplicationController
  def login
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      token = create_token(@user.id)
      render status: :ok
    else
      # TODO: エラーハンドリングまとめて適用
      render status: :unauthorized
    end
  end
end
