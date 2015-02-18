require "rails_helper"

RSpec.describe "Alpha::Control", :type => :request do

  let!(:user) { create(:user, mlh: true) }

  context "no access token" do
  end

  context "with access token" do
  end
end
