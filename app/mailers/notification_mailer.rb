class NotificationMailer < ActionMailer::Base
  default from: "hi@hackcentral.co"

  def welcome_email(user)
    @user = user

    mail(
      to: "#{user.email}",
      subject: "Welcome to HackCentral!"
    )

  end
end
