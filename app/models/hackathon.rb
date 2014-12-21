class Hackathon < ActiveRecord::Base

  has_many :applications
  has_many :submissions
  has_many :organizers

  has_attached_file :logo, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/

  has_attached_file :header, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment_content_type :header, :content_type => /\Aimage\/.*\Z/

  validates :name, presence: true
  validates :subdomain, presence: true
  validates :about, presence: true
  validates :tagline, presence: true
  validates :location, presence: true
  validates :start, presence: true
  validates :end, presence: true
end
