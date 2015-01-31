module Alpha

  module Entities
    class Application < Grape::Entity
      expose :id
      expose :reimbursement_needed, documentation: { type: "Boolean", desc: "If user needs travel reimbursement" }
      expose :profile_id, documentation: { type: "Integer", desc: "ID of profile" }
      expose :hackathon_id, documentation: { type: "Integer", desc: "ID of hackathon applying to" }
      expose :user_id
      expose :created_at
      expose :updated_at
    end
  end

  class Applications < Grape::API
    use WineBouncer::OAuth2

    desc "Show all applications (Doorkeeper Auth)", auth: { scopes: [] }, entity: Alpha::Entities::Application
      get '/applications', http_codes: [ [200, "Ok", Alpha::Entities::Application] ] do
        applications = Application.where(user_id: resource_owner).all
        present applications, with: Alpha::Entities::Application
      end

    desc "Create an application (Doorkeeper Auth)", auth: { scopes: [] }, entity: Alpha::Entities::Application
      params do
        requires :reimbursement_needed, type: Boolean, desc: "If user needs travel reimbursement"
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

  end
end