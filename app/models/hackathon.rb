class Hackathon < ActiveRecord::Base
  has_attached_file :logo, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/

  has_attached_file :header, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment_content_type :header, :content_type => /\Aimage\/.*\Z/
end
