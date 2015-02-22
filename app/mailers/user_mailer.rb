class UserMailer < ApplicationMailer

  default from: "from@example.com"

  def application_confirmation
    @greeting = "Hi"
    mail to: "to@example.org", subject: "Application confirmation"
  end
end
