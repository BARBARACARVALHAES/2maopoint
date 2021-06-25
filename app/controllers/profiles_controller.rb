class ProfilesController < ApplicationController
  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def invitations
    @user = current_user
    authorize @user
    @trades = Trade.where(buyer: @user).or(Trade.where(seller: @user)).order(date: :asc)
  end
end
