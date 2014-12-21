require 'rails_helper'

RSpec.describe "organizers/new", :type => :view do
  before(:each) do
    assign(:organizer, Organizer.new(
      :user_id => 1,
      :hackathon_id => 1
    ))
  end

  it "renders new organizer form" do
    render

    assert_select "form[action=?][method=?]", organizers_path, "post" do

      assert_select "input#organizer_user_id[name=?]", "organizer[user_id]"

      assert_select "input#organizer_hackathon_id[name=?]", "organizer[hackathon_id]"
    end
  end
end
