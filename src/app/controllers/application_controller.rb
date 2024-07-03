class ApplicationController < ActionController::API
  def create_token(user_id)
    session_token = JWT.encode(payload(user_id), secret_key)

    session_token
  end

  def current_user
    @current_user
  end

  def authenticate_user!
    @current_user ||= User.find(decoded_token[0]["user_id"])
  end

  private

  def payload(user_id)
    {user_id: user_id, exp: (DateTime.current + 14.days).to_i}
  end

  def decoded_token
    JWT.decode(token, secret_key)
  end

  def token
    authorization_header.split(" ")[1]
  end

  def authorization_header
    request.headers[:authorization]
  end

  def secret_key
    Rails.application.credentials.secret_key_base
  end
end
