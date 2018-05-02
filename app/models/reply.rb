class Reply < ApplicationRecord
  belongs_to :user
  belongs_to :comment, :dependent => :destroy
  validates :content, presence: true
end
