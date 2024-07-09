class Api::Password::ResetsController < Api::PasswordsController
  def create
    user = User.find_by!(email: params["email"])
    handle_reset_token(user)
    render status: :ok
  end

  def update
    user = User.find_by!(password_reset_token: params["token"])
    if user.password_reset_token_valid?
      user.reset_password(params["password"])
    end

    render status: :ok
  end
end
