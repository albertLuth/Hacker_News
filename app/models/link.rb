class Link < ApplicationRecord
  belongs_to :user
  def upvotes
    votes.sum(:upvote)
  end
end
