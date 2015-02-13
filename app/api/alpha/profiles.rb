module Alpha

  module Entities
    class Profile < Grape::Entity
      expose :id
      expose :name, documentation: { type: "String", desc: "Name" }
      expose :school_grad, documentation: { type: "String", desc: "Year of graduation" }
      expose :website, documentation: { type: "String", desc: "Website" }
      expose :github, documentation: { type: "String", desc: "GitHub" }
      expose :created_at
      expose :updated_at
      expose :resume_url
      expose :dietary_needs, documentation: { type: "String", desc: "Dietary needs" }
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
  end
end