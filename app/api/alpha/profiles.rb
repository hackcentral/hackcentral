module Alpha

  module Entities
    class Profile < Grape::Entity
      expose :id
      expose :name
      expose :school_grad
      expose :website
      expose :github
      expose :created_at
      expose :updated_at
      expose :resume
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

    desc "Create a profile (Doorkeeper Auth)", auth: { scopes: [] }, entity: Alpha::Entities::Profile
      params do
        requires :name, type: String, desc: "Name"
        requires :school_grad, type: String, desc: "Year of school graduation"
        optional :website, type: String, desc: "Website"
        optional :github, type: String, desc: "GitHub"
        optional :resume, type: String, desc: "Resume"
        optional :dietary_needs, type: String, desc: "Dietary Needs"
      end

      post '/profiles', http_codes: [ [200, "Ok", Alpha::Entities::Profile] ] do
        profile = Profile.new
        profile.name = params[:name]
        profile.school_grad = params[:school_grad]
        profile.website = params[:website] if params[:website]
        profile.github = params[:github] if params[:github]
        profile.resume = params[:resume] if params[:resume]
        profile.dietary_needs = params[:dietary_needs] if params[:dietary_needs]
        profile.user_id = resource_owner.id
        profile.save

        status 201
        present profile, with: Alpha::Entities::Profile
      end

    desc "Show a profile (Doorkeeper Auth)", auth: { scopes: [] }, entity: Alpha::Entities::Profile
      params do
        requires :id, type: Integer, desc: "ID of profile"
      end

      get '/profiles/:id', http_codes: [ [200, "Ok", Alpha::Entities::Profile] ] do
        @profile = Profile.find(params[:id])

        if @profile.user_id == resource_owner.id
          status 200
          present @profile, with: Alpha::Entities::Profile
        else
          Rack::Response.new({
            error: "unauthorized_oauth",
            error_description: "Please supply a valid access token."
          }.to_json, 401).finish
        end
      end

    desc "Update a profile (Doorkeeper Auth)", auth: { scopes: [] }, entity: Alpha::Entities::Profile
      params do
        optional :name, type: String, desc: "Name"
        optional :school_grad, type: String, desc: "Year of school graduation"
        optional :website, type: String, desc: "Website"
        optional :github, type: String, desc: "GitHub"
        optional :resume, type: String, desc: "Resume"
        optional :dietary_needs, type: String, desc: "Dietary Needs"
      end

      put '/profiles/:id', http_codes: [ [200, "Ok", Alpha::Entities::Profile] ] do
        @profile = Profile.find(params[:id])

        if @profile.user_id == resource_owner.id
          @profile.name = params[:name] if params[:name]
          @profile.school_grad = params[:school_grad] if params[:school_grad]
          @profile.website = params[:website] if params[:website]
          @profile.github = params[:github] if params[:github]
          @profile.resume = params[:resume] if params[:resume]
          @profile.dietary_needs = params[:dietary_needs] if params[:dietary_needs]
          @profile.save

          status 200
          present @profile, with: Alpha::Entities::Profile
        else
          Rack::Response.new({
            error: "unauthorized_oauth",
            error_description: "Please supply a valid access token."
          }.to_json, 401).finish
        end
      end

    desc "Delete a profile (Doorkeeper Auth)", auth: { scopes: [] }, entity: Alpha::Entities::Profile
      params do
        requires :id, type: Integer, desc: "ID of application"
      end

      delete '/profiles/:id', http_codes: [ [200, "Ok", Alpha::Entities::Profile] ] do
        @profile = Profile.find(params[:id])

        if @profile.user_id == resource_owner.id
          Profile.destroy(params[:id])
          status 204
        else
          Rack::Response.new({
            error: "unauthorized_oauth",
            error_description: "Please supply a valid access token."
          }.to_json, 401).finish
        end
      end
  end
end