module StepsControllers
  class TradesStepsController < ApplicationController
    include Wicked::Wizard
    require 'uri'
    require 'net/http'

    steps(*Trade.form_steps.keys)

    def show
      @trade = Trade.find(params[:trade_id])
      # On the page of the carrefour unit f1zemos tudo ligado à geoloclização
      @geoloc_success = true if @carrefour_units
      @carrefour_units ||= CarrefourUnit.all.order(name: :asc)
      search_for_localisation if params[:id] == 'carrefour_unit'
      authorize @trade
      render_wizard
    end

    def update
      @trade = Trade.find(params[:trade_id])
      authorize @trade
      @trade.assign_attributes(trade_params)
      @trade.author_role == "Vendedor" ? @trade.update(seller: current_user) : @trade.update(buyer: current_user)
      receiver = User.find_by(phone: @trade.receiver_phone)
      @trade.buyer = receiver if @trade.seller == current_user && receiver
      @trade.seller = receiver if @trade.buyer == current_user && receiver
      # If it is the last step
      if @trade.save && params[:id] == Trade.form_steps.keys.last
        @trade.created_by_seller? ? @trade.update(seller_accepted: true) : @trade.update(buyer_accepted: true)
        user = User.find_by(phone: @trade.receiver_phone)
        url = user ? confirm_screen_trade_url(@trade) : new_user_registration_url
        receiver_name = user ? user.first_name : @trade.receiver_name
        WhatsappCreateTradeJob.perform_later(phone: @trade.receiver_phone, receiver_name: receiver_name, sender_user: current_user, trade: @trade, url: url)
        # TwilioClient.new.created_trade(phone: @trade.receiver_phone, receiver_name: receiver_name, sender_user: current_user, trade: @trade, url: url)
        # TradeMailer.with(receiver_email: @trade.receiver_email, receiver_name: @trade.receiver_name, sender_user: current_user, trade: @trade).created_trade.deliver_later
        redirect_to(finish_wizard_path, success: "O pedido foi enviado pelo WhatsApp para #{@trade.receiver_phone}!")
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

    def search_for_localisation
      # Get the localisation of the buyer_cep and seller_cep
      if @trade.seller_cep.present? && @trade.buyer_cep.present?
        # Transform CEP into lat / long
        uri_buyer = URI("https://viacep.com.br/ws/#{@trade.buyer_cep}/json/")
        res_buyer = Net::HTTP.get_response(uri_buyer)
        json_buyer = JSON.parse(res_buyer.body)
        address_buyer = "#{json_buyer['logradouro']} #{json_buyer['localidade']}"
        if Geocoder.search(address_buyer).first.present?
          coordinates = Geocoder.search(address_buyer).first.coordinates
          @trade.lat_buyer = coordinates[0]
          @trade.long_buyer = coordinates[1]
        end

        uri_seller = URI("https://viacep.com.br/ws/#{@trade.seller_cep}/json/")
        res_seller = Net::HTTP.get_response(uri_seller)
        json_seller = JSON.parse(res_seller.body)
        address_seller = "#{json_seller['logradouro']} #{json_seller['localidade']}"
        if Geocoder.search(address_seller).first.present?
          coordinates = Geocoder.search(address_seller).first.coordinates
          @trade.lat_seller = coordinates[0]
          @trade.long_seller = coordinates[1]
        end

        @markers_users = [{lat: @trade.lat_seller, lng: @trade.long_seller, current: @trade.seller == current_user}, {lat: @trade.lat_buyer, lng: @trade.long_buyer, current: @trade.buyer == current_user} ]

        if @trade.lat_seller.present? && @trade.long_seller.present? && @trade.lat_buyer.present? && @trade.long_buyer.present?
          order_by_loc(@trade)
        end

        # Generate API MAP
        @markers = @carrefour_units.all.geocoded.map do |unit|
          {
            lat: unit.latitude,
            lng: unit.longitude,
            info_window: render_to_string(partial: "info_window", locals: { unit: unit }),
            id: unit.id
          }
        end
      end
    end

    def order_by_loc(trade)
      # Get the center point between the two users
      center_point = Geocoder::Calculations.geographic_center([[trade.lat_buyer, trade.long_buyer], [trade.lat_seller, trade.long_seller]])
      @carrefour_units = CarrefourUnit.near(center_point, 1_000_000, order: :distance)
    end
  end
end
