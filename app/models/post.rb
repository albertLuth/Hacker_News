class Post < ApplicationRecord
  validates :title, length: {maximum: 30}, presence: true
  validates :user, presence: true
end
