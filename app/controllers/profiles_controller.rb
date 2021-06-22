class ProfilesController < ApplicationController
  def show
    TradeMailer.with(user: current_user).created_trade.deliver_now
  end
end
