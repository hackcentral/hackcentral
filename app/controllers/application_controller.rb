class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :identify_user, if: :user_signed_in?
  helper_method :current_hackathon

  protected
    def self.matches?(request)
      request.subdomain.present? && request.subdomain != 'www'
      def current_hackathon
        @current_hackathon ||= Hackathon.find_by_subdomain!(request.subdomain)
      end
    end

    def identify_user
      Analytics.identify(
      user_id: "#{current_user.id}",
      traits: { name: "#{current_user.name}", username: "#{current_user.username}", email: "#{current_user.email}"}
    )
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << :name
      devise_parameter_sanitizer.for(:account_update) << :name
      devise_parameter_sanitizer.for(:account_update) << :bio
      devise_parameter_sanitizer.for(:account_update) << :username
      devise_parameter_sanitizer.for(:account_update) << :avatar
    end
  end