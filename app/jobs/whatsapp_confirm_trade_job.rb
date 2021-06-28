class WhatsappConfirmTradeJob < ApplicationJob
  queue_as :default

  def perform(args = {})
    TwilioClient.new.confirmed_trade({phone: args[:phone], reciver_name: args[:receiver_name], sender_user: args[:sender_user], trade: args[:trade], url: args[:url]})
  end
end
