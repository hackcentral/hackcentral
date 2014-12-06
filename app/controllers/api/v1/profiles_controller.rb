module Api
  module V1
    class ProfilesController < ApplicationController
      doorkeeper_for :all
      respond_to :json

      def index
        respond_with current_user.profiles
      end

      def show
        respond_with current_user.profile(params[:profile])
      end

      def create
        respond_with current_user.profiles.create(params[:profile])
      end

      def update
        respond_with current_user.profiles.update(params[:profile])
      end

      def destroy
        respond_with current_user.profiles.destroy(params[:profile])
      end
    end
  end
end
