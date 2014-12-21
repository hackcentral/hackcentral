require 'rails_helper'

RSpec.describe "organizers/show", :type => :view do
  before(:each) do
    @organizer = assign(:organizer, Organizer.create!(
      :user_id => 1,
      :hackathon_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
  end
end
