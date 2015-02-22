require "rails_helper"

RSpec.describe UserMailer, :type => :mailer do
  describe "application_confirmation" do
    let(:user) { FactoryGirl.create(:user) }
    let(:hackathon) { FactoryGirl.create(:hackathon) }
    let(:mail) { UserMailer.application_confirmation(user, hackathon) }

    it "renders the headers" do
      expect(mail.subject).to eq("#{hackathon.name} Application Submitted")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["support@hackcentral.co"])
    end
  end

end
