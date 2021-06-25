class TradesController < ApplicationController
  before_action :set_trade, only: %i[edit destroy update confirm_presence confirm_screen]

  def index
    @trades = policy_scope(Trade)
    authorize @trades
  end

  def new
    @trade = Trade.new
    @trade.author = current_user
    authorize @trade
    # We save an instance of the trade in database even if not valid
    @trade.save!(validate: false)
    # We redirect to trade_step_path in order to begin the Wizard form
    redirect_to trade_step_path(@trade, Trade.form_steps.keys.first)
    authorize @trade
  end

  def edit; end

  def update
    if current_user == @trade.seller
      @trade.update(seller_accepted: true)
      @trade.update(buyer_accepted: false)
    else
      @trade.update(seller_accepted: false)
      @trade.update(buyer_accepted: true)
    end
    if @trade.update(trade_params)
      redirect_to(confirm_screen_trade_path(@trade), success: "As informações foram modificadas com sucesso, um email foi mandado para a outra para confirmação !")
    else
      render :edit
    end
  end

  def destroy
    redirect_to invitations_profile_path if @trade.destroy
  end


  def confirm_presence
    current_user == @trade.buyer ? @trade.update(buyer_accepted: true) : @trade.update(seller_accepted: true)
    redirect_to confirm_screen_trade_path(@trade)
  end

  def confirm_screen; end

  private

  def set_trade
    @trade = Trade.find(params[:id])
    authorize @trade
  end

  def trade_params
    params.require(:trade).permit(:carrefour_unit_id, :date)
  end
end
