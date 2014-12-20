module Api
  module V1
    class HackathonsController < ApplicationController
      doorkeeper_for :all

      def index
        @hackathons = Hackathon.all

        respond_to do |format|
          format.json { render :json => @hackathons }
        end
      end

      def show
        @hackathon = Hackathon.find(params[:id])

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
        @hackathon = Hackathon.find(params[:id])

        respond_to do |format|
          if @hackathon.update(hackathon_params)
            format.json { render :json => @hackathon, status: :ok }
          else
            format.json { render json: @hackathon.errors, status: :unprocessable_entity }
          end
        end
      end

      def destroy
        @hackathon = Hackathon.find(params[:id])
        @hackathon.destroy

        respond_to do |format|
          format.json { head :no_content }
        end
      end

      private
        def hackathon_params
          params.require(:hackathon).permit(:name, :subdomain, :about, :tagline, :location, :logo, :header, :start, :end, :hs_hackers_allowed, :mlh_sanctioned)
        end
    end
  end
end
