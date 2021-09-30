class BlogComment < ApplicationRecord

  belongs_to :user
  belongs_to :blog

  validates :comment, {presence: true, length: {maximum: 200 }}
end
