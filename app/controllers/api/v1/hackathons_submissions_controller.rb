module Api
  module V1
    class HackathonsSubmissionsController < ApplicationController
      doorkeeper_for :all
      respond_to :json

      def index
        respond_with current_hackathon.submissions
      end

      def create
        respond_with current_hackathon.submissions.create(params[:submission])
      end

      def update
        respond_with current_hackathon.submissions.update(params[:submission])
      end

      def destroy
        respond_with current_hackathon.submissions.destroy(params[:submission])
      end

      private
        def current_hackathon
          current_hackathon == Hackathon.find(params[:hackathon_id])
        end
    end
  end
end
