module Alpha

  class Checkin < Grape::API
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
        requires :checked_in, type: Boolean, desc: "Accpted to hackathon, true/false"
      end

      get '/hackathons/:hackathon_id/applications', http_codes: [ [200, "Ok", Alpha::Entities::Application] ] do
        @hackathon = Hackathon.find(params[:hackathon_id])

        if @hackathon.user_id == resource_owner.id or resource_owner.organizers.where(hackathon_id: @hackathon)
          if params[:checked_in] = "true"
            @applications = Application.where(hackathon_id: @hackathon, checked_in: true)
            status 200
            present @applications, with: Alpha::Entities::Application

          elsif params[:checked_in] = "false"
            @applications = Application.where(hackathon_id: @hackathon, checked_in: false)
            status 200
            present @applications, with: Alpha::Entities::Application
          end
        else
          Rack::Response.new({
            error: "unauthorized_oauth",
            error_description: "Please supply a valid access token."
          }.to_json, 401).finish
        end
      end

    desc "Checkin an application (Doorkeeper Auth)", auth: { scopes: [] }, entity: Alpha::Entities::Application
      params do
        requires :hackathon_id, type: Integer, desc: "ID of hackathon that is being sanctioned"
        requires :application_id, type: Integer, desc: "ID of application"
      end

      put "/hackathons/:hackathon_id/applications/:application_id/checkin", http_codes: [ [200, "Ok", Alpha::Entities::Application] ] do
        @hackathon = Hackathon.find(params[:hackathon_id])

        if @hackathon.user_id == resource_owner.id or resource_owner.organizers.where(hackathon_id: @hackathon)
          @application = Application.find(params[:application_id])

          @application.checked_in = true
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

    desc "Uncheckin an application (Doorkeeper Auth)", auth: { scopes: [] }, entity: Alpha::Entities::Application
      params do
        requires :hackathon_id, type: Integer, desc: "ID of hackathon that is being sanctioned"
        requires :application_id, type: Integer, desc: "ID of application"
      end

      put "/hackathons/:hackathon_id/applications/:application_id/uncheckin", http_codes: [ [200, "Ok", Alpha::Entities::Application] ] do
        @hackathon = Hackathon.find(params[:hackathon_id])

        if @hackathon.user_id == resource_owner.id or resource_owner.organizers.where(hackathon_id: @hackathon)
          @application = Application.find(params[:application_id])

          @application.checked_in = false
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
  end
end