class User < ApplicationRecord
  has_secure_password
  has_many :todos, dependent: :destroy

  enum register_status: { incomplete: "incomplete", complete: "complete" }

  def generate_register_token
    self.register_token = generate_token
    self.register_token_sent_at = Time.zone.now
    save!
  end

  def register_token_valid?
    (self.register_token_sent_at + 1.hour) > Time.zone.now
  end

  def current_password?(current_password)
    authenticate(current_password).present?
  end

  def generate_password_reset_token
    self.password_reset_token = generate_token
    self.password_reset_token_sent_at = Time.zone.now
    save!
  end

  def password_reset_token_valid?
    (self.password_reset_token_sent_at + 1.hour) > Time.zone.now
  end

  def reset_password(new_password)
    self.password = new_password
    save!
  end

  private

  def generate_token
    SecureRandom.alphanumeric(10)
  end
end
