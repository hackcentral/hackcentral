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
      expose :logo_url
      expose :header_url
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

    desc "Create an hackathon (Doorkeeper Auth)", auth: { scopes: [] }, entity: Alpha::Entities::Hackathon
      params do
        requires :name, type: String, desc: "Name of hackathon"
        requires :about, type: String, desc: "About of hackathon"
        requires :tagline, type: String, desc: "Tagline of hackathon"
        requires :location, type: String, desc: "Location of hackathon"
        requires :hs_hackers_allowed, type: String, desc: "If hs_hackers_allowed at hackathon"
        requires :subdomain, type: String, desc: "Subdomain of hackathon"
        requires :start, type: String, desc: "Start time of hackathon"
        requires :end, type: String, desc: "End time of hackathon"
      end

      post '/hackathons', http_codes: [ [200, "Ok", Alpha::Entities::Hackathon] ] do
        hackathon = Hackathon.new
        hackathon.name = params[:name]
        hackathon.about = params[:about]
        hackathon.tagline = params[:tagline]
        hackathon.location = params[:location]
        hackathon.hs_hackers_allowed = params[:hs_hackers_allowed]
        hackathon.subdomain = params[:subdomain]
        hackathon.start = params[:start]
        hackathon.end = params[:end]
        hackathon.user_id = resource_owner.id
        hackathon.save

        status 201
        present hackathon, with: Alpha::Entities::Hackathon
      end

    desc "Show a hackathon (Doorkeeper Auth)", auth: { scopes: [] }, entity: Alpha::Entities::Hackathon
      params do
        requires :id, type: Integer, desc: "ID of hackathon"
      end

      get '/hackathons/:id', http_codes: [ [200, "Ok", Alpha::Entities::Hackathon] ] do
        @hackathon = Hackathon.find(params[:id])

        status 200
        present @hackathon, with: Alpha::Entities::Hackathon
      end
  end
end