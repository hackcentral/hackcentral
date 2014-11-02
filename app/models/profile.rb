class Profile < ActiveRecord::Base
  has_attached_file :resume, content_type: { content_type: "application/pdf" }
end
