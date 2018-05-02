class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post, :dependent => :destroy
  belongs_to :comment, optional: true
  validates :content, presence: true
end
