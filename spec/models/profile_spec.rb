require "rails_helper"

describe Profile do
  it "has a valid factory" do
    FactoryGirl.build(:profile).should be_valid
  end

  it { should belong_to(:user) }

  it { should have_many(:applications) }

  it "is invalid without a name" do
    FactoryGirl.build(:profile, :name => nil).should_not be_valid
  end
  it "is invalid without a school_grad" do
    FactoryGirl.build(:profile, :school_grad => nil).should_not be_valid
  end

  it { should have_attached_file(:resume) }
  it { should validate_attachment_content_type(:resume).
    allowing('application/pdf', 'application/pdf').
    rejecting('image/png', 'image/gif') }
end
