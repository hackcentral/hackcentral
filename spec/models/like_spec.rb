require "rails_helper"

describe Like do
  it "has a valid factory" do
    FactoryGirl.build(:like).should be_valid
  end

  it { should belong_to(:user) }
  it { should belong_to(:submission) }

end
