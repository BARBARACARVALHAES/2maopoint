class WhatsappConfirmTradeJob < ApplicationJob
  queue_as :default

  def perform(args = {})
    TwilioClient.new.confirmed_trade({phone: args[:phone], name: args[:name], other_trader: args[:other_trader], trade: args[:trade], url: args[:url]})
  end
end
