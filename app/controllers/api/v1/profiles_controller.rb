module Api
  module V1
    class ProfilesController < ApplicationController
      doorkeeper_for :all
      respond_to :json

      def index
        respond_with current_user.profiles
      end
      #def show
        #respond_with Profile.find(params[:id])
      #end
    end
  end
end
