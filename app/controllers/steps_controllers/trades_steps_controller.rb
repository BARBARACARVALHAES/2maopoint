module StepsControllers
  class TradesStepsController < ApplicationController
    include Wicked::Wizard

    steps(*Trade.form_steps.keys)

    def show
      @trade = Trade.find(params[:trade_id])
      authorize @trade
      render_wizard
    end

    def update
      @trade = Trade.find(params[:trade_id])
      authorize @trade
      @trade.assign_attributes(trade_params)
      @trade.author_role == "Vendedor" ? @trade.update(seller: current_user) : @trade.update(buyer: current_user)
      receiver = User.find_by(email: @trade.receiver_email)
      @trade.buyer = receiver if @trade.seller && receiver
      @trade.seller = receiver if @trade.buyer && receiver
      # If it is the last step
      if @trade.save && params[:id] == Trade.form_steps.keys.last
        @trade.created_by_seller? ? @trade.update(seller_accepted: true) : @trade.update(buyer_accepted: true)
        TradeMailer.with(receiver_email: @trade.receiver_email, receiver_name: @trade.receiver_name, sender_user: current_user, trade: @trade).created_trade.deliver_later
        redirect_to(finish_wizard_path, success: "O pedido foi enviado para #{@trade.receiver_email}!")
      else
        render_wizard @trade
      end
    end

    private

    def trade_params
      params.require(:trade).permit(Trade.form_steps[step]).merge(form_step: step.to_sym)
    end

    def finish_wizard_path
      profile_path(current_user)
    end
  end
end
