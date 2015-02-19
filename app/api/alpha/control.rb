module Alpha

  class Control < Grape::API
    format :json
    use WineBouncer::OAuth2

    rescue_from WineBouncer::Errors::OAuthUnauthorizedError do |e|
      Rack::Response.new({
        error: "unauthorized_oauth",
        error_description: "Please supply a valid access token."
      }.to_json, 401).finish
    end

    desc "Show all applications to hackathon (Doorkeeper Auth)", auth: { scopes: [] }, entity: Alpha::Entities::Application
      params do
        requires :hackathon_id, type: Integer, desc: "ID of hackathon"
      end


      get '/hackathons/:hackathon_id/applications', http_codes: [ [200, "Ok", Alpha::Entities::Application] ] do
        @hackathon = Hackathon.find(params[:hackathon_id])

        if @hackathon.user_id == resource_owner.id or resource_owner.organizers.where(hackathon_id: @hackathon)
          @applications = Application.where(hackathon_id: @hackathon)
          status 200
          present @applications, with: Alpha::Entities::Application
        else
          Rack::Response.new({
            error: "unauthorized_oauth",
            error_description: "Please supply a valid access token."
          }.to_json, 401).finish
        end
      end
  end
end