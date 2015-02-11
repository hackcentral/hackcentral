module Alpha
  module Entities
    class User < Grape::Entity
      expose :id
      expose :created_at
      expose :updated_at
      expose :name
      expose :bio
      expose :username
    end
  end

  class Users < Grape::API
    format :json
    use WineBouncer::OAuth2

    rescue_from WineBouncer::Errors::OAuthUnauthorizedError do |e|
      Rack::Response.new({
        error: "unauthorized_oauth",
        error_description: "Please supply a valid access token."
      }.to_json, 401).finish
    end

    desc "Show current_user's information (Doorkeeper Auth)", auth: { scopes: [] }, entity: Alpha::Entities::User
      get '/user', http_codes: [ [200, "Ok", Alpha::Entities::User] ] do
        @user = User.find_by_id(resource_owner.id)

        status 200
        present @user, with: Alpha::Entities::User
      end
  end
end