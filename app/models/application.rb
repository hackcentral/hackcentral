class Application < ActiveRecord::Base
  belongs_to :user
  belongs_to :profile
  belongs_to :hackathon
end
