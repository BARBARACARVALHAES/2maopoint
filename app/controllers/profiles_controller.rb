class ProfilesController < ApplicationController
  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def invitations
    @user = current_user
    authorize @user
    # TODO: passar esta lógica para "after_sign_up"
    policy_scope(Trade).each do |trade|
      if trade.receiver_email == @user.email
        trade.update(receiver_name: @user.first_name) if @user.first_name
        trade.author_role == "Vendedor" ? trade.update(buyer: @user) : trade.update(seller: @user)
      end
    end
    @trades = Trade.where(buyer: @user).or(Trade.where(seller: @user))
  end
end
