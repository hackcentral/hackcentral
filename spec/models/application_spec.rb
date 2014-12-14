require "rails_helper"

describe Application do
  it "has a valid factory" do
    FactoryGirl.build(:application).should be_valid
  end

  it { should belong_to(:user) }
  it { should belong_to(:profile) }
  it { should belong_to(:hackathon) }

  it "is invalid without a name" do
    FactoryGirl.build(:application, :name => nil).should_not be_valid
  end
  it "is invalid without a first_name" do
    FactoryGirl.build(:application, :first_name => nil).should_not be_valid
  end
  it "is invalid without a last_name" do
    FactoryGirl.build(:application, :last_name => nil).should_not be_valid
  end
  it "is invalid without a email" do
    FactoryGirl.build(:application, :email => nil).should_not be_valid
  end
  it "is invalid without a school_grad" do
    FactoryGirl.build(:application, :school_grad => nil).should_not be_valid
  end
  it "is invalid without a bio" do
    FactoryGirl.build(:application, :bio => nil).should_not be_valid
  end
end
