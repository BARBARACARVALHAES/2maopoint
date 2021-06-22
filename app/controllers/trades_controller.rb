class TradesController < ApplicationController
  before_action :set_trade, only: %i[edit destroy]

  def index
    @trades = policy_scope(Trade)
  end

  def new
    @trade = Trade.new
    # We save an instance of the trade in database even if not valid
    @trade.save!(validate: false)
    # We redirect to trade_step_path in order to begin the Wizard form
    redirect_to trade_step_path(@trade, Trade.form_steps.keys.first)
    authorize @trade
  end

  def edit; end

  def update
    @trade = Trade.find(params[:id])
    @trade.update(trade_params)
  end

  def destroy
    @trade.destroy
  end

  private

  def set_trade
    @trade = Trade.find(params[:id])
    authorize @trade
  end

  def trade_params
    params.require(:trade).permit(:carrefour_unit_id, :date)
  end
end
