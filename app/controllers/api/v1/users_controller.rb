module Api
  module V1
    class UsersController < ApplicationController
      doorkeeper_for :all
      respond_to :json

      def show
        respond_with current_user.as_json(:except => [:encrypted_password, :reset_password_token, :reset_password_sent_at,
        :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip])
      end
    end
  end
end
