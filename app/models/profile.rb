class Profile < ActiveRecord::Base
  has_attached_file :resume
  validates_attachment_content_type :resume, :content_type => "application/pdf"

  belongs_to :user

  has_many :applications

  validates :name, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :school_grad, presence: true
  validates :bio, presence: true
end
