class User < ApplicationRecord

  # has_many :posts

  validates :name, presence: true
  validates :password, presence: true
end