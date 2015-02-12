module Alpha

  module Entities
    class Hackathon < Grape::Entity
      expose :id
      expose :name
      expose :about
      expose :tagline
      expose :location
      expose :created_at
      expose :updated_at
      expose :start
      expose :end
      expose :hs_hackers_allowed, documentation: { type: "Boolean", desc: "If HS Hackers are allowed" }
      expose :mlh_sanctioned, documentation: { type: "Boolean", desc: "If hackathon has been sanctioned by MLH" }
      expose :subdomain
      expose :user_id
    end
  end

  class Hackathons < Grape::API
    format :json
    use WineBouncer::OAuth2

    rescue_from WineBouncer::Errors::OAuthUnauthorizedError do |e|
      Rack::Response.new({
        error: "unauthorized_oauth",
        error_description: "Please supply a valid access token."
      }.to_json, 401).finish
    end

    desc "Show all hackathons (Doorkeeper Auth)", auth: { scopes: [] }, entity: Alpha::Entities::Hackathon
      get '/hackathons', http_codes: [ [200, "Ok", Alpha::Entities::Hackathon] ] do
        hackathons = Hackathon.all
        present hackathons, with: Alpha::Entities::Hackathon
      end
  end
end