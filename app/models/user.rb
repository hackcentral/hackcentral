class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :profiles
  has_many :applications
  has_many :submissions
  has_many :oauth_applications, class_name: 'Doorkeeper::Application', as: :owner

  after_init :send_welcome_email

private
  def send_welcome_email
    NotificationMailer.welcome_email(user).deliver_now
  end

end
