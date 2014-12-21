require 'rails_helper'

RSpec.describe "organizers/index", :type => :view do
  before(:each) do
    assign(:organizers, [
      Organizer.create!(
        :user_id => 1,
        :hackathon_id => 2
      ),
      Organizer.create!(
        :user_id => 1,
        :hackathon_id => 2
      )
    ])
  end

  it "renders a list of organizers" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
