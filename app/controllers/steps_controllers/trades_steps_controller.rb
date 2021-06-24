module StepsControllers
  class TradesStepsController < ApplicationController
    include Wicked::Wizard
    require 'uri'
    require 'net/http'

    steps(*Trade.form_steps.keys)

    def show
      @trade = Trade.find(params[:trade_id])
      # On the page of the carrefour unit f1zemos tudo ligado à geoloclização
      search_for_localisation if params[:id] == 'carrefour_unit'
      render_wizard
    end

    def update
      @trade = Trade.find(params[:trade_id])
      @trade.assign_attributes(trade_params)
      # If it is the last step
      if @trade.save && params[:id] == Trade.form_steps.keys.last
        TradeMailer.with(receiver_email: @trade.receiver_email, sender_user: current_user, trade: @trade).created_trade.deliver_later
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
      @trade.author_role == "Vendedor" ? @trade.update(seller: current_user) : @trade.update(buyer: current_user)
      profile_path(current_user)
    end

    def search_for_localisation
      # Generate API MAP
      @markers = CarrefourUnit.all.geocoded.map do |unit|
        {
          lat: unit.latitude,
          lng: unit.longitude,
          info_window: render_to_string(partial: "info_window", locals: { unit: unit })
        }
      end

      # Get the localisation of the buyer_cep and seller_cep
      if @trade.seller_cep.present? && @trade.buyer_cep.present?
        # Transform CEP into lat / long
        uri_buyer = URI("https://viacep.com.br/ws/#{@trade.buyer_cep}/json/")
        res_buyer = Net::HTTP.get_response(uri_buyer)
        json_buyer = JSON.parse(res_buyer.body)
        address_buyer = "#{json_buyer['logradouro']} #{json_buyer['localidade']}"
        coordinates = Geocoder.search(address_buyer).first.coordinates
        @trade.lat_buyer = coordinates[0]
        @trade.long_buyer = coordinates[1]

        uri_seller = URI("https://viacep.com.br/ws/#{@trade.seller_cep}/json/")
        res_seller = Net::HTTP.get_response(uri_seller)
        json_seller = JSON.parse(res_seller.body)
        address_seller = "#{json_seller['logradouro']} #{json_seller['localidade']}"
        coordinates = Geocoder.search(address_seller).first.coordinates
        @trade.lat_seller = coordinates[0]
        @trade.long_seller = coordinates[1]

        order_by_loc(@trade)
      end
    end

    def order_by_loc(trade)
      # Get the center point between the two users
      center_point = Geocoder::Calculations.geographic_center([[trade.lat_buyer, trade.long_buyer], [trade.lat_seller, trade.long_seller]])
      @carrefour_units = CarrefourUnit.near(center_point, 1000000, order: :distance)
    end
  end
end
