class Profile < ActiveRecord::Base
  has_attached_file :resume
  validates_attachment_content_type :resume, :content_type => "application/pdf"
end
