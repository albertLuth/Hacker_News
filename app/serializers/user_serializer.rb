class UserSerializer < ActiveModel::Serializer
    attributes :id, :name, :email, :about, :created_at, :updated_at

  end
