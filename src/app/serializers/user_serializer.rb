class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :register_status, :token

  def token
    instance_options[:token]
  end
end
