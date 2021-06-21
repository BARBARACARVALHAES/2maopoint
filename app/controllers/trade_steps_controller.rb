class TradeStepsController < ApplicationController
  include Wicked::Wizard
  steps :trade_details, :calendar, :location, :invitation
  before_action :authenticate_user!

  def show
    @user = current_user
    case step
    when :trade_details
      @trade = Trade.new
      @item_categories = ItemCategory.all
    end
    render_wizard
  end

  def update
  end

  private

  def set_trade
    @trade = Trade.find(params[:trade_id])
  end
end
