module Alpha

  class MLH < Grape::API
    format :json
    use WineBouncer::OAuth2

    rescue_from WineBouncer::Errors::OAuthUnauthorizedError do |e|
      Rack::Response.new({
        error: "unauthorized_oauth",
        error_description: "Please supply a valid access token."
      }.to_json, 401).finish
    end

    desc "Sanction a hackathon (Doorkeeper Auth)", auth: { scopes: [] }, entity: Alpha::Entities::Hackathon
      params do
        requires :hackathon_id, type: Integer, desc: "ID of hackathon that is being sanctioned"
      end

      put '/mlh/sanction/:hackathon_id', http_codes: [ [200, "Ok", Alpha::Entities::Hackathon] ] do
        @hackathon = Hackathon.find(params[:hackathon_id])

        if resource_owner.mlh?
          @hackathon.mlh_sanctioned = true
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

    desc "Unsanction a hackathon (Doorkeeper Auth)", auth: { scopes: [] }, entity: Alpha::Entities::Hackathon
      params do
        requires :hackathon_id, type: Integer, desc: "ID of hackathon that is being sanctioned"
      end

      put '/mlh/unsanction/:hackathon_id', http_codes: [ [200, "Ok", Alpha::Entities::Hackathon] ] do
        @hackathon = Hackathon.find(params[:hackathon_id])

        if resource_owner.mlh?
          @hackathon.mlh_sanctioned = false
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
  end
end