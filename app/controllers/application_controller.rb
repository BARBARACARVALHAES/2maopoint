class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  include Pundit

  add_flash_types :success, :failed
end
