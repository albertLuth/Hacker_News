class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post, :dependent => :destroy
  belongs_to :comment, optional: true
  validates :content, presence: true

  def upvotes
    comment_votes.sum(:upvote)
  end

  def downvotes
    comment_votes.sum(:downvote)
  end

  def calc_hot_score
    points = upvotes - downvotes
    update_attributes(points: points)
  end
    has_many :comment_votes
end
