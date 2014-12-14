require "rails_helper"

describe User do
  it "has a valid factory" do
    FactoryGirl.build(:user).should be_valid
  end

  it { should have_many(:profiles) }
  it { should have_many(:applications) }
  it { should have_many(:submissions) }
  it { should have_many(:likes) }
  it { should have_many(:oauth_applications) }

end
