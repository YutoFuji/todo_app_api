class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :register_status
end
