class Api::Password::ForgotsController < Api::PasswordsController
  before_action :authenticate_user!, only: [:create]

  def create
    if current_user.email
      handle_reset_token(current_user)
      render status: :ok
    else
      render status: :not_found
    end
  end
end
