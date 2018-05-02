class ReplyVote < ApplicationRecord
  belongs_to :user
  belongs_to :reply
  has_many :reply_votes
  validates :user_id, uniqueness: { scope: :reply_id }
end
