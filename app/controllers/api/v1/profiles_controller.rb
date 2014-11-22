module Api
  module V1
    class ProfilesController < ApplicationController
      doorkeeper_for :all
      respond_to :json

      def index
        user = User.find(doorkeeper_token.resource_owner_id)
        respond_with user.profiles
      end
      #def show
        #respond_with Profile.find(params[:id])
      #end
    end
  end
end
