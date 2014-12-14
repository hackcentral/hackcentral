require "rails_helper"

describe Application do
  it "has a valid factory" do
    FactoryGirl.build(:application).should be_valid
  end

  it { should belong_to(:user) }
  it { should belong_to(:profile) }
  it { should belong_to(:hackathon) }

end
