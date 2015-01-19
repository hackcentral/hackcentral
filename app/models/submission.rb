class Submission < ActiveRecord::Base

  belongs_to :user
  belongs_to :hackathon

  has_many :team_members
    accepts_nested_attributes_for :team_members, :reject_if => :all_blank, :allow_destroy => true
  has_many :likes
  has_many :taggings
  has_many :tags, through: :taggings

  validates :title, presence: true
  validates :tagline, presence: true

  extend FriendlyId
  friendly_id :title, use: :slugged

  def self.tagged_with(name)
    Tag.find_by_name!(name).submissions
  end

  def self.tag_counts
    Tag.select("tags.*, count(taggings.tag_id) as count").
      joins(:taggings).group("taggings.tag_id")
  end

  def tag_list
    tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end
end
