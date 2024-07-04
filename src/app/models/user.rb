class User < ApplicationRecord
  has_secure_password
  has_many :todos, dependent: :destroy

  def current_password?(current_password)
    authenticate(current_password).present?
  end

  def generate_password_reset_token
    self.password_reset_token = generate_reset_token
    self.password_reset_token_sent_at = Time.zone.now
    save!
  end

  def valid_password_reset_token?
    (self.password_reset_token_sent_at + 1.hour) > Time.zone.now
  end

  def reset_password(new_password)
    self.password = new_password
    save!
  end

  private

  def generate_reset_token
    SecureRandom.alphanumeric(10)
  end
end
