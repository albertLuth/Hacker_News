class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :votes
  validates :user_id, uniqueness: { scope: :post_id }
end
