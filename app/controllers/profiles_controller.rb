class ProfilesController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def invitations
    @user = current_user
    @trades = Trade.where(buyer: @user).or(Trade.where(seller: @user))
  end
end
