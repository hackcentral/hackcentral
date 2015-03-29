module Alpha
  module Entities
    class Submission < Grape::Entity
      expose :id
      expose :title
      expose :tagline
      expose :description
      expose :video
      expose :website
      expose :created_at
      expose :updated_at
      expose :user_id
      expose :hackathon_id
      expose :submitted_at
      expose :slug
    end
  end

  class Submissions < Grape::API
    format :json
    use WineBouncer::OAuth2

    rescue_from WineBouncer::Errors::OAuthUnauthorizedError do |e|
      Rack::Response.new({
        error: "unauthorized_oauth",
        error_description: "Please supply a valid access token."
      }.to_json, 401).finish
    end

    desc "Show all submissions for @hackathon (Doorkeeper Auth)", auth: { scopes: [] }, entity: Alpha::Entities::Submission
      params do
        requires :hackathon_id, type: Integer, desc: "ID of hackathon"
      end

      get '/submissions', http_codes: [ [200, "Ok", Alpha::Entities::Submission] ] do
        @hackathon = Hackathon.where(id: params[:hackathon_id])
        submissions = Submission.where(hackathon_id: @hackathon).all
        present submissions, with: Alpha::Entities::Submission
      end

    desc "Show a submission (Doorkeeper Auth)", auth: { scopes: [] }, entity: Alpha::Entities::Submission
      params do
        requires :id, type: Integer, desc: "ID of submission"
      end

      get '/submissions/:id', http_codes: [ [200, "Ok", Alpha::Entities::Submission] ] do
        @submission = Submission.find(params[:id])
        if @submission.submitted_at == nil
          Rack::Response.new({
            error: "unauthorized_oauth",
            error_description: "Please supply a valid access token."
          }.to_json, 401).finish
        elsif @submission.submitted_at == nil && @submission.user_id = resource_owner.id
          status 200
          present @submission, with: Alpha::Entities::Submission
        else
          status 200
          present @submission, with: Alpha::Entities::Submission
        end
      end
  end
end