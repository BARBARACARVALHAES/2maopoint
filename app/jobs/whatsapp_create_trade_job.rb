class WhatsappCreateTradeJob < ApplicationJob
  queue_as :default

  def perform(args = {})
    TwilioClient.new.created_trade({phone: args[:phone], receiver_name: args[:receiver_name], sender_user: args[:sender_user], trade: args[:trade], url: args[:url]})
  end
end
