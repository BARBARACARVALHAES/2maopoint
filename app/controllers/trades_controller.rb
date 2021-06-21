class TradesController < ApplicationController
  before_action :set_trade, only: %i[create edit update destroy]

  def index
    @trades = policy_scope(Trade)
  end

  def new
    @trade = Trade.new
    authorize @trade
  end

  def create
    @trade = Trade.new(trade_params)
    @trade.save
  end

  def edit; end

  def update
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
    params.require(:trade).permit(:item, :item_category_id, :buyer_id, :seller_id, :carrefour_unit_id, :date,
                                  :buyer_cep, :seller_cep, :receiver_email)
  end
end
