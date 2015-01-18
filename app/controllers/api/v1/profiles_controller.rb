module Api
  module V1
    class ProfilesController < ApplicationController
      protect_from_forgery unless: -> { request.format.json? }
      before_action :doorkeeper_authorize!
      before_action :set_profile, only: [:show, :update, :destroy]
      before_action :correct_user, only: [:show, :edit, :update, :destroy]

      def index
        @profiles = Profile.where(user_id: current_user).all

        respond_to do |format|
          format.json { render :json => @profiles }
        end
      end

      def show
        #@profile = Profile.find(params[:id])
        respond_to do |format|
          format.json { render :json => @profile }
        end
      end

      def create
        @profile = Profile.create!(profile_params.merge(user_id: current_user.id)) #(user_id: current_user)) #Application.new(application_params)

        respond_to do |format|
          if @profile.save(profile_params)
            format.json { render :json => @profile, status: :created }
          else
            format.json { render status: 422 }
          end
        end
      end

      def update
        respond_to do |format|
          if @profile.update(profile_params)
            format.json { render :json => @profile, status: :ok }
          else
            format.json { render json: @profile.errors, status: :unprocessable_entity }
          end
        end
      end

      def destroy
        @profile.destroy

        respond_to do |format|
          format.json { head :no_content }
        end
      end

      private
        def set_profile
          @profile = Profile.find(params[:id])
        end

        def correct_user
          @profile = Profile.find(params[:id])
          if @profile.user_id == current_user.id
          else
            respond_to do |format|
              format.json { render :json => {}, status: 401} #if @application.nil?
            end
          end
        end

        def profile_params
          params.require(:profile).permit(:name, :first_name, :last_name, :email, :school_grad, :bio, :website, :github, :dietary_needs, :resume, :user_id)
        end
    end
  end
end
