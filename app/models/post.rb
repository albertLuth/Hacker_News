class Post < ApplicationRecord

  # belongs_to :user

  # validates :user_id, presence: true
  validates :title, presence: true, length: {maximum: 60}

  validate :text_xor_url

  private

  def text_xor_url
    unless text.blank? ^ url.blank?
      errors.add(:base, "Specify a text or a url, not both")
    end
  end
end
