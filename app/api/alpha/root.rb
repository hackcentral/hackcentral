module Alpha
  class Root < Grape::API
    version 'v1', using: :path
    format :json

    # Mountings
    mount Alpha::Applications
    mount Alpha::Hackathons
    mount Alpha::Users

    #desc "Returns pong."
    #get "ping" do
      #{ ping: "pong" }
    #end

    #route :any, '*path' do
      #error! # or something else
    #end

  end
end