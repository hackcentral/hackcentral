require "rails_helper"

describe User do
  it "has a valid factory" do
    FactoryGirl.build(:user).should be_valid
  end

  it { should have_many(:hackathons) }
  it { should have_many(:organizers) }
  it { should have_many(:profiles) }
  it { should have_many(:applications) }
  it { should have_many(:submissions) }
  it { should have_many(:team_members) }
  it { should have_many(:likes) }
  it { should have_many(:oauth_applications) }

  it { should have_attached_file(:avatar) }
  it { should validate_attachment_content_type(:avatar).
    allowing('image/png', 'image/gif').
    rejecting('text/plain', 'text/xml') }

end
