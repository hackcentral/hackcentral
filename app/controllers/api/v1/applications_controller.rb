module Api
  module V1
    class ApplicationsController < ApplicationController
      doorkeeper_for :all

      def index
        # respond_with @applications = Application.where(user_id: current_user.id).all
        @applications = Application.where(user_id: current_user).all

        respond_to do |format|
          format.json { render :json => @applications } #, :only => [:id, :reimbursement_needed, :accepted] }
        end
      end

      def show
        @application = Application.find(params[:id])

        respond_to do |format|
          format.json { render :json => @application }
        end
      end

      def create
        @application = Application.create!(application_params.merge(user_id: current_user)) #Application.new(application_params)

        respond_to do |format|
          if @application.save
            format.json { render :json => @application, status: :created }
          else
            format.json { render :json => @application.errors, status: :unprocessable_entity }
          end
        end
      end

      def update
        @application = Application.find(params[:id])

        respond_to do |format|
          if @application.update(application_params)
            format.json { render :json => @application, status: :ok }
          else
            format.json { render json: @application.errors, status: :unprocessable_entity }
          end
        end
      end

      def destroy
        @application = Application.find(params[:id])
        @application.destroy

        respond_to do |format|
          format.json { head :no_content }
        end
      end

      private
        def application_params
          params.require(:application).permit(:reimbursement_needed, :accepted, :user_id, :profile_id, :hackathon_id)
        end
    end
  end
end
