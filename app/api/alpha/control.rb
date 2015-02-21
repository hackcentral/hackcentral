module Alpha

  module Entities
    class Organizer < Grape::Entity
      expose :id
      expose :user_id
      expose :hackathon_id
      expose :created_at
      expose :updated_at

    end
  end

  class Control < Grape::API
    format :json
    use WineBouncer::OAuth2

    rescue_from WineBouncer::Errors::OAuthUnauthorizedError do |e|
      Rack::Response.new({
        error: "unauthorized_oauth",
        error_description: "Please supply a valid access token."
      }.to_json, 401).finish
    end

    desc "Update a hackathon (Doorkeeper Auth)", auth: { scopes: [] }, entity: Alpha::Entities::Hackathon
      params do
        optional :name, type: String, desc: "Name of hackathon"
        optional :about, type: String, desc: "About of hackathon"
        optional :tagline, type: String, desc: "Tagline of hackathon"
        optional :location, type: String, desc: "Location of hackathon"
        optional :start, type: String, desc: "Start time of hackathon"
        optional :end, type: String, desc: "End time of hackathon"
        optional :logo, desc: "Logo image of hackathon"
        optional :header, desc: "Header image of hackathon"
        optional :hs_hackers_allowed, type: String, desc: "If hs_hackers_allowed at hackathon"
        optional :subdomain, type: String, desc: "Subdomain of hackathon"
      end

      put '/hackathons/:id', http_codes: [ [200, "Ok", Alpha::Entities::Hackathon] ] do
        @hackathon = Hackathon.find(params[:id])

        if @hackathon.user_id == resource_owner.id or resource_owner.organizers.where(hackathon_id: @hackathon)

          @hackathon.name = params[:name] if params[:name]
          @hackathon.about = params[:about] if params[:about]
          @hackathon.tagline = params[:tagline] if params[:tagline]
          @hackathon.location = params[:location] if params[:location]
          @hackathon.start = params[:start] if params[:start]
          @hackathon.end = params[:end] if params[:end]
          @hackathon.logo = params[:logo] if params[:logo]
          @hackathon.header = params[:header] if params[:header]
          @hackathon.hs_hackers_allowed = params[:hs_hackers_allowed] if params[:hs_hackers_allowed]
          @hackathon.subdomain = params[:subdomain] if params[:subdomain]
          @hackathon.save

          status 200
          present @hackathon, with: Alpha::Entities::Hackathon
        else
          Rack::Response.new({
            error: "unauthorized_oauth",
            error_description: "Please supply a valid access token."
          }.to_json, 401).finish
        end
      end

    desc "Delete a hackathon (Doorkeeper Auth)", auth: { scopes: [] }, entity: Alpha::Entities::Hackathon
      params do
        requires :id, type: Integer, desc: "ID of hackathon"
      end

      delete '/hackathons/:id', http_codes: [ [200, "Ok", Alpha::Entities::Hackathon] ] do
        @hackathon = Hackathon.find(params[:id])

        if @hackathon.user_id == resource_owner.id or resource_owner.organizers.where(hackathon_id: @hackathon)
          Hackathon.destroy(params[:id])
          status 204
        else
          Rack::Response.new({
            error: "unauthorized_oauth",
            error_description: "Please supply a valid access token."
          }.to_json, 401).finish
        end
      end

    desc "Show all organizers for hackathon (Doorkeeper Auth)", auth: { scopes: [] }, entity: Alpha::Entities::Organizer
      params do
        requires :hackathon_id, type: Integer, desc: "ID of hackathon"
      end

      get '/hackathons/:hackathon_id/organizers', http_codes: [ [200, "Ok", Alpha::Entities::Organizer] ] do
        @hackathon = Hackathon.find(params[:hackathon_id])

        if @hackathon.user_id == resource_owner.id or resource_owner.organizers.where(hackathon_id: @hackathon)
          organizers = Organizer.where(hackathon_id: @hackathon).all

          status 200
          present organizers, with: Alpha::Entities::Organizer
        else
          Rack::Response.new({
            error: "unauthorized_oauth",
            error_description: "Please supply a valid access token."
          }.to_json, 401).finish
        end
      end

    desc "Create organizer for hackathon (Doorkeeper Auth)", auth: { scopes: [] }, entity: Alpha::Entities::Organizer
      params do
        requires :hackathon_id, type: Integer, desc: "ID of hackathon"
        requires :user_id, type: Integer, desc: "ID of user"
      end

      post '/hackathons/:hackathon_id/organizers', http_codes: [ [200, "Ok", Alpha::Entities::Organizer] ] do
        @hackathon = Hackathon.find(params[:hackathon_id])

        if @hackathon.user_id == resource_owner.id or resource_owner.organizers.where(hackathon_id: @hackathon)
          @organizer = Organizer.new
          @organizer.hackathon_id = params[:hackathon_id]
          @organizer.user_id = params[:user_id]
          @organizer.save

          status 201
          present @organizer, with: Alpha::Entities::Organizer
        else
          Rack::Response.new({
            error: "unauthorized_oauth",
            error_description: "Please supply a valid access token."
          }.to_json, 401).finish
        end
      end

  end
end