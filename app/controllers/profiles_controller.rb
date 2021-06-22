class ProfilesController < ApplicationController
  def invitations
    @user = current_user
    @trades = Trade.where(buyer: @user).or(Trade.where(seller: @user))
  end
end
