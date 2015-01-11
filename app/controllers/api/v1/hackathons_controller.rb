module Api
  module V1
    class HackathonsController < ApplicationController
      before_action :doorkeeper_authorize!
      before_action :set_hackathon, only: [:show, :edit, :update, :destroy]

      def index
        @hackathons = Hackathon.all

        respond_to do |format|
          format.json { render :json => @hackathons }
        end
      end

      def show
        respond_to do |format|
          format.json { render :json => @hackathon }
        end
      end

      def create
        @hackathon = Hackathon.create!(hackathon_params) #Application.new(application_params)

        respond_to do |format|
          if @hackathon.save(hackathon_params)
            format.json { render :json => @hackathon, status: :created }
          else
            format.json { render :json => @hackathon.errors, status: :unprocessable_entity }
          end
        end
      end

      def update
        respond_to do |format|
          if @hackathon.update(hackathon_params)
            format.json { render :json => @hackathon, status: :ok }
          else
            format.json { render json: @hackathon.errors, status: :unprocessable_entity }
          end
        end
      end

      def destroy
        @hackathon.destroy

        respond_to do |format|
          format.json { head :no_content }
        end
      end

      private
        def set_hackathon
          @hackathon = Hackathon.find(params[:id])
        end

        def hackathon_params
          params.require(:hackathon).permit(:name, :subdomain, :about, :tagline, :location, :logo, :header, :start, :end, :hs_hackers_allowed, :mlh_sanctioned)
        end
    end
  end
end
