require "rails_helper"

describe Hackathon do
  it "has a valid factory" do
    FactoryGirl.build(:hackathon).should be_valid
  end

  it { should belong_to(:user) }

  it { should have_many(:applications) }
  it { should have_many(:submissions) }
  it { should have_many(:organizers) }

  it "is invalid without a name" do
    FactoryGirl.build(:hackathon, :name => nil).should_not be_valid
  end
  it "is invalid without a subdomain" do
    FactoryGirl.build(:hackathon, :subdomain => nil).should_not be_valid
  end
  it "is invalid without a about" do
    FactoryGirl.build(:hackathon, :about => nil).should_not be_valid
  end
  it "is invalid without a tagline" do
    FactoryGirl.build(:hackathon, :tagline => nil).should_not be_valid
  end
  it "is invalid without a location" do
    FactoryGirl.build(:hackathon, :location => nil).should_not be_valid
  end
  it "is invalid without a start" do
    FactoryGirl.build(:hackathon, :start => nil).should_not be_valid
  end
  it "is invalid without a end" do
    FactoryGirl.build(:hackathon, :end => nil).should_not be_valid
  end
end
