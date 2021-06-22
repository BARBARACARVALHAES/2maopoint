class ProfilesController < ApplicationController
  def invitations
    @user = current_user
    @authored_trades = Trade.where(author: @user.id)
  end
end
