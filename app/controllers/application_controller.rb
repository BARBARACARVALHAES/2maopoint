class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  include Pundit

  def after_sign_in_path_for(resource)
    profile_path(resource)
  end

  add_flash_types :success, :failed

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :cpf, :birthdate, :phone, :address])
  end
  
end

