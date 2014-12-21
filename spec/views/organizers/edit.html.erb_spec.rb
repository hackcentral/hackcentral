require 'rails_helper'

RSpec.describe "organizers/edit", :type => :view do
  before(:each) do
    @organizer = assign(:organizer, Organizer.create!(
      :user_id => 1,
      :hackathon_id => 1
    ))
  end

  it "renders the edit organizer form" do
    render

    assert_select "form[action=?][method=?]", organizer_path(@organizer), "post" do

      assert_select "input#organizer_user_id[name=?]", "organizer[user_id]"

      assert_select "input#organizer_hackathon_id[name=?]", "organizer[hackathon_id]"
    end
  end
end
