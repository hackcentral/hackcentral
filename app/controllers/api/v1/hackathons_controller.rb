module Api
  module V1
    class HackathonsController < ApplicationController
      doorkeeper_for :all
      respond_to :json

      def index
        respond_with Hackathon.all
      end

      def show
        respond_with Hackathon.find(params[:id])
      end

      def create
        respond_with current_user.hackathons.create(params[:hackathon])
      end

      def update
        respond_with current_user.hackathons.update(params[:hackathon])
      end

      def destroy
        respond_with current_user.hackathons.destroy(params[:hackathon])
      end
    end
  end
end
