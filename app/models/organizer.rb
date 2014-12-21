class Organizer < ActiveRecord::Base
  belongs_to :user
  belongs_to :hackathon

  def user_username
    user.try(:username)
  end

  def user_username=(username)
    self.user = User.find_by_username(username) if username.present?
  end
end
