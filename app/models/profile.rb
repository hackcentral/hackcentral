class Profile < ActiveRecord::Base

  belongs_to :user

  has_many :applications

  has_attached_file :resume
  validates_attachment_content_type :resume, :content_type => "application/pdf"

  validates :name, presence: true
  validates :school_grad, presence: true
end
