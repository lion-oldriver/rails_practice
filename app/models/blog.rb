class Blog < ApplicationRecord
  
  belongs_to :user
  attachment :image
end
