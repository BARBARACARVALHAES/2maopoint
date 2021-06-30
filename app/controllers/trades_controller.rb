class TradesController < ApplicationController
  before_action :set_trade, only: %i[edit destroy update confirm_presence confirm_screen]
  before_action :search_user, only: %i[update destroy confirm_presence]

  def index
    @trades = policy_scope(Trade)
    authorize @trades
  end

  def new
    @trade = Trade.new
    @trade.author = current_user
    authorize @trade
    # We save an instance of the trade in database even if not valid
    @trade.save!(validate: false)
    # We redirect to trade_step_path in order to begin the Wizard form
    redirect_to trade_step_path(@trade, Trade.form_steps.keys.first)
    authorize @trade
  end

  def edit; end

  def update
    if @trade.update(trade_params)
      if current_user == @trade.seller
        @trade.update(seller_accepted: true, buyer_accepted: false)
        # TradeMailer.with(receiver_email: receiver_email, receiver_name: receiver_name, sender_user: current_user, trade: @trade).update_trade.deliver_later
      else
        @trade.update(seller_accepted: false, buyer_accepted: true)
        # TradeMailer.with(receiver_email: receiver_email, receiver_name: receiver_name, sender_user: current_user, trade: @trade).update_trade.deliver_later
      end
      receiver_infos = get_receiver_infos
      WhatsappUpdateTradeJob.perform_later(phone: receiver_infos[:receiver_phone], receiver_name: receiver_infos[:receiver_name], sender_user: current_user, trade: @trade, url: @url)
      redirect_to(confirm_screen_trade_path(@trade), success: "As informações foram modificadas com sucesso, uma mensagem WhatsApp foi mandado para #{receiver_infos[:receiver_name]} para confirmação !")
    else
      render :edit
    end
  end

  def destroy
    receiver_infos = get_receiver_infos
    if @trade.destroy
      WhatsappDestroyTradeJob.perform_later(phone: receiver_infos[:receiver_phone], receiver_name: receiver_infos[:receiver_name], sender_user: current_user, trade: @trade, url: @url)
      redirect_to(invitations_profile_path, success: "Você cancelou esse agendamento, uma mensagem foi mandada para avisar #{receiver_infos[:receiver_name]}")
    else
      render 'profiles/invitations'
    end
  end


  def confirm_presence
    current_user == @trade.buyer ? @trade.update(buyer_accepted: true) : @trade.update(seller_accepted: true)
    receiver_infos = get_receiver_infos
    if @trade.buyer_accepted == true && @trade.seller_accepted == true
      WhatsappConfirmTradeJob.perform_now(phone: receiver_infos[:receiver_phone], receiver_name: receiver_infos[:receiver_name], sender_user: current_user, trade: @trade, url: @url)
    end
    # TradeMailer.with(receiver_email: @trade.receiver_email, receiver_name: @trade.receiver_name, sender_user: current_user, trade: @trade).confirm_trade.deliver_later
    redirect_to(confirm_screen_trade_path(@trade), success: "Você confirmou a sua presença para esse encontro !")
  end

  def confirm_screen; end

  private

  def get_receiver_infos
    if current_user == @trade.seller
      receiver_phone = @trade.buyer ? @trade.buyer.phone : @trade.receiver_phone
      receiver_name = @trade.buyer ? @trade.buyer.name : @trade.receiver_name
      receiver_email = @trade.buyer ? @trade.buyer.email : @trade.receiver_email
    else
      receiver_phone = @trade.seller ? @trade.seller.phone : @trade.receiver_phone
      receiver_name = @trade.seller ? @trade.seller.name : @trade.receiver_name
      receiver_email = @trade.seller ? @trade.seller.email : @trade.receiver_email
    end
    { receiver_phone: receiver_phone, receiver_name: receiver_name, receiver_email: receiver_email }
  end

  def set_trade
    @trade = Trade.find(params[:id])
    authorize @trade
  end

  def trade_params
    params.require(:trade).permit(:carrefour_unit_id, :date)
  end

  def search_user
    user = User.find_by(phone: @trade.receiver_phone)
    @url = user ? confirm_screen_trade_url(@trade) : new_user_registration_url
  end
end
