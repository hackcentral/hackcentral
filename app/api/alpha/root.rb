module Alpha
  class Root < Grape::API
    version 'v1', using: :path
    format :json

    # Regular Mountings
    mount Alpha::Applications
    mount Alpha::Hackathons
    mount Alpha::Profiles
    mount Alpha::Users
    mount Alpha::Submissions

    # Admin Mountings
    mount Alpha::Accept
    mount Alpha::Checkin
    mount Alpha::Control
    mount Alpha::MLH

    #desc "Returns pong."
    #get "ping" do
      #{ ping: "pong" }
    #end

    #route :any, '*path' do
      #error! # or something else
    #end


  end
end