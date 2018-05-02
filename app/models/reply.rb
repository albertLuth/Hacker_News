class Reply < ApplicationRecord
  belongs_to :user
  belongs_to :comment, :dependent => :destroy
  validates :content, presence: true

    def upvotes
      reply_votes.sum(:upvote)
    end

    def downvotes
      reply_votes.sum(:downvote)
    end

    def calc_hot_score
      points = upvotes - downvotes
      update_attributes(points: points)
    end
      has_many :reply_votes
end
