class CommentVote < ApplicationRecord
  belongs_to :user
  belongs_to :comment
  has_many :comment_votes
  validates :user_id, uniqueness: { scope: :comment_id }
end
