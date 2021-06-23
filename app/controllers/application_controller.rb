class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  include Pundit

  def after_sign_in_path_for(resource)
    profile_path(resource)
  end

  add_flash_types :success, :failed
end

