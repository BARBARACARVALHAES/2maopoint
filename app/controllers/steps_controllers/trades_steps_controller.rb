module StepsControllers
  class TradesStepsController < ApplicationController
    include Wicked::Wizard

    steps(*Trade.form_steps.keys)

    def show
      @trade = Trade.find(params[:trade_id])
      render_wizard
    end

    def update
      @trade = Trade.find(params[:trade_id])
      @trade.assign_attributes(trade_params)
      render_wizard @trade
    end

    private

    def trade_params
      params.require(:trade).permit(Trade.form_steps[step]).merge(form_step: step.to_sym)
    end

    def finish_wizard_path
      TradeMailer.with(receiver_email: @trade.receiver_email, sender_user: current_user, trade: @trade).created_trade.deliver_later
      profile_path(current_user)
    end
  end
end
