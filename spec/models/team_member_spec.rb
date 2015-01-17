require 'rails_helper'

RSpec.describe TeamMember do
  it "has a valid factory" do
    FactoryGirl.build(:team_member).should be_valid
  end

  it { should belong_to(:submission) }
  it { should belong_to(:user) }

end
