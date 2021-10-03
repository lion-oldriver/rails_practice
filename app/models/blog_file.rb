class BlogFile < ApplicationRecord
  belongs_to :blog
  attachment :image
end
