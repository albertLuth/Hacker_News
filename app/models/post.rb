class Post < ApplicationRecord

  belongs_to :user

  validates :user_id, presence: true
  validates :title, presence:
            true,
            length: {maximum: 60}
  validates :title,
            presence: true,
            uniqueness: { case_sensitive: false }

  validates :url,
            format: { with: %r{\Ahttps?://} },
            allow_blank: true

  validate :text_xor_url



  def text_xor_url
    unless text.blank? ^ url.blank?
      errors.add(:base, "Specify a text or a url, not both")
    end
  end

  def upvotes
    votes.sum(:upvote)
  end

  def downvotes
    votes.sum(:downvote)
  end

  def calc_hot_score
    points = upvotes - downvotes
  end


  def hot_score(points, time_ago_in_hours, gravity = 1.8)
    # one is subtracted from available points because every link by default has one point
    # There is no reason for picking 1.8 as gravity, just an arbitrary value
    (points - 1) / (time_ago_in_hours + 2) ** gravity
  end
  scope :hottest, -> { order(hot_score: :desc) }
  scope :newest, -> { order(created_at: :desc) }
  has_many :votes
end
