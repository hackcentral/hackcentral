module Alpha

  module Entities
    class Application < Grape::Entity
      expose :id
      expose :reimbursement_needed, documentation: { type: "Boolean", desc: "If user needs travel reimbursement" }
      expose :created_at
      expose :updated_at
      expose :user_id
      expose :profile_id, documentation: { type: "Integer", desc: "ID of profile" }
      expose :hackathon_id, documentation: { type: "Integer", desc: "ID of hackathon applying to" }
      expose :accepted #, documentation: { type: "String", desc: "If application was accepted to hackathon" }
      expose :checked_in #, documentation: { type: "String", desc: "If application was checked_in to hackathon" }
    end
  end

  class Applications < Grape::API
    format :json
    use WineBouncer::OAuth2

    rescue_from WineBouncer::Errors::OAuthUnauthorizedError do |e|
      Rack::Response.new({
        error: "unauthorized_oauth",
        error_description: "Please supply a valid access token."
      }.to_json, 401).finish
    end

    desc "Show all applications (Doorkeeper Auth)", auth: { scopes: [] }, entity: Alpha::Entities::Application
      get '/applications', http_codes: [ [200, "Ok", Alpha::Entities::Application] ] do
        applications = Application.where(user_id: resource_owner).all
        present applications, with: Alpha::Entities::Application
      end

    desc "Create an application (Doorkeeper Auth)", auth: { scopes: [] }, entity: Alpha::Entities::Application
      params do
        requires :reimbursement_needed, type: String, desc: "If user needs travel reimbursement"
        requires :profile_id, type: Integer, desc: "ID of profile"
        requires :hackathon_id, type: Integer, desc: "ID of hackathon applying to"
      end

      post '/applications', http_codes: [ [200, "Ok", Alpha::Entities::Application] ] do
        application = Application.new
        application.reimbursement_needed = params[:reimbursement_needed] if params[:reimbursement_needed]
        application.profile_id = params[:profile_id] if params[:profile_id]
        application.hackathon_id = params[:hackathon_id] if params[:hackathon_id]
        application.user_id = resource_owner.id
        application.save

        status 201
        present application, with: Alpha::Entities::Application
      end

    desc "Show an application (Doorkeeper Auth)", auth: { scopes: [] }, entity: Alpha::Entities::Application
      params do
        requires :id, type: Integer, desc: "ID of application"
      end

      get '/applications/:id', http_codes: [ [200, "Ok", Alpha::Entities::Application] ] do
        application = Application.find(params[:id])
        present application, with: Alpha::Entities::Application
      end

    desc "Update an application (Doorkeeper Auth)", auth: { scopes: [] }, entity: Alpha::Entities::Application
      params do
        requires :reimbursement_needed, type: String, desc: "If user needs travel reimbursement"
        requires :profile_id, type: Integer, desc: "ID of profile"
        # You cannot change the hackathon_id for which you are applying.
      end

      put '/applications/:id', http_codes: [ [200, "Ok", Alpha::Entities::Application] ] do
        @application = Application.find(params[:id])

        if @application.user_id == resource_owner.id
          @application.reimbursement_needed = params[:reimbursement_needed] if params[:reimbursement_needed]
          @application.profile_id = params[:profile_id] if params[:profile_id]
          @application.save

          status 200
          present @application, with: Alpha::Entities::Application
        else
          Rack::Response.new({
            error: "unauthorized_oauth",
            error_description: "Please supply a valid access token."
          }.to_json, 401).finish
        end
      end

      patch '/applications/:id', http_codes: [ [200, "Ok", Alpha::Entities::Application] ] do
        @application = Application.find(params[:id])

        if @application.user_id == resource_owner
          @application.reimbursement_needed = params[:reimbursement_needed] if params[:reimbursement_needed]
          @application.profile_id = params[:profile_id] if params[:profile_id]
          @application.save

          status 200
          present @application, with: Alpha::Entities::Application
        else
          Rack::Response.new({
            error: "unauthorized_oauth",
            error_description: "Please supply a valid access token."
          }.to_json, 401).finish
        end
      end

    desc "Delete an application (Doorkeeper Auth)", auth: { scopes: [] }, entity: Alpha::Entities::Application
      params do
        requires :id, type: Integer, desc: "ID of application"
      end

      delete '/applications/:id', http_codes: [ [200, "Ok", Alpha::Entities::Application] ] do
        @application = Application.find(params[:id])

        if @application.user_id == resource_owner.id
          Application.destroy(params[:id])
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