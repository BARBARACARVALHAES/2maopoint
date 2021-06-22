class TradesController < ApplicationController
  include Wicked::Wizard
  steps :calendar, :location, :invitation, :confirmation
  before_action :set_trade, only: %i[edit destroy]

  def index
    @trades = policy_scope(Trade)
  end

  def new
    @trade = Trade.new
    @item_categories = ItemCategory.all
    authorize @trade
  end

  def create
    @trade = Trade.new(trade_params)
    if params[:author] == "Vendedor"
      @trade.seller_id = current_user.id
    else
      @trade.buyer_id = current_user.id
    end
    if @trade.save
      session[:trade_id] = @trade.id
      redirect_to wizard_path(steps.first, trade_id: @trade.id)
    else
      render :new
    end
  end

  def show
    @trade = Trade.find(session[:trade])
    case step
    when :location
      @carrefour_units = CarrefourUnit.all
    end
    render_wizard
  end

  def edit; end

  def update
    @trade = Trade.find(session[:trade])
    @trade.update(trade_params)
    render_wizard @trade
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
                                  :buyer_cep, :seller_cep, :receiver_email, :author)
  end
end
