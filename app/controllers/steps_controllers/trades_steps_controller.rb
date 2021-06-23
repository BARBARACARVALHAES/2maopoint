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
      @trade.author_role == "Vendedor" ? @trade.update(seller: current_user) : @trade.update(buyer: current_user)
      profile_path(current_user)
    end
  end
end
