module Api
  module V1
    class ProfilesController < ApplicationController
      doorkeeper_for :all
      respond_to :json

      def index
        respond_with current_user.profiles
      end
      def create
        respond_with current_user.profiles.create(params[:profile])
      end
    end
  end
end
