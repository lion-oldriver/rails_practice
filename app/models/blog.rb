class Blog < ApplicationRecord

  belongs_to :user
  has_many :blog_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  attachment :image

  validates :title, presence: true
  validates :body, presence: true
  validates :image, presence: true

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  scope :evaluations, -> { order(evaluation: :desc) }
end
