require "rails_helper"

feature "Home Page" do
  scenario "succesfully" do
    visit root_path

    expect(page).to have_css 'h1', text: 'Hack Central'
  end
end

feature "About Page" do
  scenario "succesfully" do
    visit pages_about_path

    expect(page).to have_css 'h1', text: 'About'
  end
end
