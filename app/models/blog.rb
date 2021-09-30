class Blog < ApplicationRecord
  acts_as_taggable

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

  def self.last_week
    Blog.joins(:favorites).where(favorites: {created_at: 6.days.ago.beginning_of_day..Time.current}).group(:blog_id).order("count(*) desc")
  end

  scope :evaluations, -> { order(evaluation: :desc) }
end
