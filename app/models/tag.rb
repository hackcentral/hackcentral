class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :submissions, through: :taggings
end
