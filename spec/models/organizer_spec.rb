require 'rails_helper'

describe Organizer do

  it "has a valid factory" do
    FactoryGirl.build(:organizer).should be_valid
  end

  it { should belong_to(:user) }
  it { should belong_to(:hackathon) }
end
