module TwilioStub
  attr_reader :client

  def initialize(client = Twilio::REST::Client.new)
    @client = client
  end

  def created_trade(body:'blabla', to:'whatsapp:+14155238886', from: 'whatsapp:+14155238886')
    client.messages.create(
      from: from,
      to:   to,
      body: body,
    )
  end
end