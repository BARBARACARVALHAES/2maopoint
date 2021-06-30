class ProfilesController < ApplicationController
  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def invitations
    @user = current_user
    authorize @user
    # receiver_name é o ultmo campo obrigatorio, se ele existe quer dizer que o trade foi completo inteiro
    @trades = Trade.where(buyer: @user).where.not(receiver_name: nil).or(Trade.where(seller: @user).where.not(receiver_name: nil)).order(date: :asc)
  end
end
