class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  require 'will_paginate/array' #need this for will_pagination to work with Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

      # Added security when we added :name to devise form
      def configure_permitted_parameters
         devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation) }
         devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :password, :password_confirmation, :current_password) }
     end

  private

    def user_not_authorized
      flash[:danger] = "You are not authorized to perform this action."
      redirect_to(request.referrer || root_path)
    end
end
