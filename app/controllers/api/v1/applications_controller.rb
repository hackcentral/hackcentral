module Api
  module V1
    class ApplicationsController < ApplicationController
      doorkeeper_for :all
      respond_to :json

      def index
        respond_with Application.where(user_id: current_user).all
      end

      def show
        respond_with current_user.application(params[:application])
      end

      def create
        respond_with current_user.applications.create(params[:application])
      end

      def update
        respond_with current_user.applications.update(params[:application])
      end

      def destroy
        respond_with current_user.applications.destroy(params[:application])
      end
    end
  end
end
