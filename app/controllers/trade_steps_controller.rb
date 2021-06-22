class TradeStepsController < ApplicationController
  include Wicked::Wizard
  steps :trade_details, :calendar, :location, :invitation
  before_action :authenticate_user!

  def show
    @user = current_user
    @trade = Trade.find(params[:trade_id])
    @item_categories = ItemCategory.all
    @carrefour_units = CarrefourUnit.all
    case step
    when :trade_details
      if params[:created_by] == "Vendedor"
        @trade.seller_id = current_user.id
      else
        @trade.buyer_id = current_user.id
      end
    when :location
      render 'invitation' if @trade.save
    end

    @trade.save
    render_wizard
  end

  def update
    @trade = Trade.find(params[:trade_id])
    @trade.update_attributes(params[:trade])
    render_wizard @trade
  end

  def create
    @trade = Trade.new
    redirect_to wizard_path(steps.first, trade_id: @trade.id)
  end
end
