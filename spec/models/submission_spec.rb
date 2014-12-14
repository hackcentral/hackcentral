require "rails_helper"

describe Submission do
  it "has a valid factory" do
    FactoryGirl.build(:submission).should be_valid
  end

  it { should belong_to(:user) }
  it { should belong_to(:hackathon) }

  it { should have_many(:likes) }
  it { should have_many(:tags) }
  it { should have_many(:taggings) }

end
