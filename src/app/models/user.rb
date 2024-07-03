class User < ApplicationRecord
  has_secure_password
  has_many :todos, dependent: :destroy

  def current_password?(current_password)
    authenticate(current_password).present?
  end
end
