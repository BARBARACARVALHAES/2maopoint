class TradesController < ApplicationController
  before_action :set_trade, only: %i[edit destroy update confirm_presence confirm_screen set_reminder realized_trade]
  before_action :get_url, only: %i[update destroy confirm_presence]
  before_action :get_markers_users, only: %i[confirm_screen edit update]
  before_action :get_uniq_marker, only: %i[confirm_screen]
  before_action :trade_params, only: [:realized_trade]

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

  def edit
    order_by_loc
    @carrefour_units = nil if @carrefour_units.empty?
    @carrefour_units ||= CarrefourUnit.all
    get_markers
  end

  def update
    @carrefour_units ||= CarrefourUnit.all
    get_markers
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


  def set_reminder
    # WhatsappRememberTradeJob.set(wait_until: @trade.date.advance(days: -1)).perform_later.(phone: @trade.buyer.phone, name: @trade.buyer.first_name, other_trader: @trade.seller.first_name, trade: @trade, url: confirm_screen_trade_url(@trade))
    # WhatsappRememberTradeJob.set(wait_until: @trade.date.advance(days: -1)).perform_later.(phone: @trade.seller.phone, name: @trade.seller.first_name, other_trader: @trade.buyer.first_name, trade: @trade, url: confirm_screen_trade_url(@trade))
  end

  def confirm_screen
    @qr_code = RQRCode::QRCode.new("http://segunda-mao-carrefour.herokuapp.com/trades/#{@trade.id}/confirm_screen")
    @svg = @qr_code.as_svg(
      standalone: true,
      use_path: true,
      viewbox: true,
      offset: 15
    )
  end

  def realized_trade
    if trade_params[:realized] == 'realized'
      @trade.update(realized: true)
    elsif trade_params[:realized] == 'cancelled'
      @trade.update(realized: false)
    end
    redirect_to confirm_screen_trade_path(@trade), succes: "O agendamento foi atualizado com sucesso"
  end

  private
  def get_markers_users
    @markers_users = [{
      lat: @trade.lat_seller,
      lng: @trade.long_seller,
      current: @trade.seller == current_user
    },
    {
      lat: @trade.lat_buyer,
      lng: @trade.long_buyer,
      current: @trade.buyer == current_user
    }]
  end

  def get_uniq_marker
    # Generate API MAP
    @markers = [{
      lat: @trade.carrefour_unit.latitude,
      lng: @trade.carrefour_unit.longitude,
      info_window: render_to_string(partial: "steps_controllers/trades_steps/info_window", locals: { unit: @trade.carrefour_unit }),
      id: @trade.carrefour_unit.id
    }]
  end

  def get_markers
    @markers = @carrefour_units.all.geocoded.map do |unit|
      {
        lat: unit.latitude,
        lng: unit.longitude,
        info_window: render_to_string(partial: "steps_controllers/trades_steps/info_window", locals: { unit: unit }),
        id: unit.id
      }
    end
  end

  def order_by_loc
    # Get the center point between the two users
    center_point = Geocoder::Calculations.geographic_center([[@trade.lat_buyer, @trade.long_buyer], [@trade.lat_seller, @trade.long_seller]])
    @carrefour_units = CarrefourUnit.near(center_point, 1_000_000, order: :distance)
  end

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
    params.require(:trade).permit(:carrefour_unit_id, :date, :realized)
  end

  def get_url
    @url = confirm_screen_trade_url(@trade)
  end
end
