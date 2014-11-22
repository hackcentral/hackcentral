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
    end
  end
end
