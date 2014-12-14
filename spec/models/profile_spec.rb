require "rails_helper"

describe Profile do
  it "has a valid factory" do
    FactoryGirl.build(:profile).should be_valid
  end

  it "belongs to a user"
  it "has many applications"

  it "is invalid without a name" do
    FactoryGirl.build(:profile, :name => nil).should_not be_valid
  end
  it "is invalid without a first_name" do
    FactoryGirl.build(:profile, :first_name => nil).should_not be_valid
  end
  it "is invalid without a last_name" do
    FactoryGirl.build(:profile, :last_name => nil).should_not be_valid
  end
  it "is invalid without a email" do
    FactoryGirl.build(:profile, :email => nil).should_not be_valid
  end
  it "is invalid without a school_grad" do
    FactoryGirl.build(:profile, :school_grad => nil).should_not be_valid
  end
  it "is invalid without a bio" do
    FactoryGirl.build(:profile, :bio => nil).should_not be_valid
  end
end
