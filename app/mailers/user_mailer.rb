class UserMailer < ApplicationMailer

  default from: "\"HackCentral\" <support@hackcentral.co>"

  def application_confirmation(user, hackathon)
    @user = user
    @hackathon = hackathon

    mail to: user.email, subject: "#{hackathon.name} Application Submitted"
  end
end
