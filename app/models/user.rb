class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :hackathons
  has_many :organizers
  has_many :profiles
  has_many :applications
  has_many :submissions
  has_many :team_members
  has_many :likes
  has_many :oauth_applications, class_name: 'Doorkeeper::Application', as: :owner

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }
    validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  def likes?(submission)
    submission.likes.where(user_id: id).any?
  end

end
