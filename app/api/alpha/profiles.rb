module Alpha

  module Entities
    class Profile < Grape::Entity
      expose :name
      expose :school_grad
      expose :website
      expose :github
      expose :created_at
      expose :updated_at
      expose :resume_url
      expose :dietary_needs
      expose :user_id
    end
  end

  class Profiles < Grape::API
    format :json
    use WineBouncer::OAuth2

    rescue_from WineBouncer::Errors::OAuthUnauthorizedError do |e|
      Rack::Response.new({
        error: "unauthorized_oauth",
        error_description: "Please supply a valid access token."
      }.to_json, 401).finish
    end

    desc "Show all profiles (Doorkeeper Auth)", auth: { scopes: [] }, entity: Alpha::Entities::Profile
      get '/profiles', http_codes: [ [200, "Ok", Alpha::Entities::Profile] ] do
        profiles = Profile.where(user_id: resource_owner).all
        present profiles, with: Alpha::Entities::Profile
      end
  end
end