class TradeStepsController < ApplicationController
  include Wicked::Wizard
  steps :trade_details, :calendar, :location, :invitation
  before_action :authenticate_user!

  def show
    @user = current_user
    @trade = Trade.new
    @item_categories = ItemCategory.all
    @carrefour_units = CarrefourUnit.all
    case step
    when :location
      render 'invitation' if @trade.save
    end

    @trade.save
    render_wizard
  end

  def update
  end

  private

  def set_trade
    @trade = Trade.find(params[:trade_id])
  end
end
