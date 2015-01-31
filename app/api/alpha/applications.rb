module Alpha

  module Entities
    class Application < Grape::Entity
      expose :id
      expose :reimbursement_needed, documentation: { type: "Boolean", desc: "If user needs travel reimbursement" }
      expose :profile_id, documentation: { type: "Integer", desc: "ID of profile" }
      expose :hackathon_id, documentation: { type: "Integer", desc: "ID of hackathon applying to" }
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

  end
end