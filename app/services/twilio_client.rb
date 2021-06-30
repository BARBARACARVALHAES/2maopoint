class TwilioClient
  attr_reader :client

  def initialize
    @client = Twilio::REST::Client.new account_sid, auth_token
  end  

  def created_trade(args = {})
    client.messages.create(
      # From is the numero given by Twillo for the whatsapp sandbox
      from: 'whatsapp:+14155238886',
      to: "whatsapp:#{args[:phone]}",
      body: "
        Olà #{args[:receiver_name]},\nVocê recebeu um agendamento da 2ª Mão Point Carrefour do *#{args[:sender_user].first_name}* para um encontro para #{args[:sender_user] == args[:trade].buyer ? "vender" : "comprar"} *#{args[:trade].item}*\n*#{args[:trade].carrefour_unit.name}*\n*#{args[:trade].date.strftime("%d/%m/%Y")}*\n*#{args[:trade].date.strftime("%H:%M")}*\nPara acessar a plataforma, segue o link: #{args[:url]}.
      "
    )
  end

  def updated_trade(args = {})
    client.messages.create(
      # From is the numero given by Twillo for the whatsapp sandbox
      from: 'whatsapp:+14155238886',
      to: "whatsapp:#{args[:phone]}",
      body: "
        Olà #{args[:receiver_name]},\nO seu agendamento da 2ª Mão Point Carrefour com *#{args[:sender_user].first_name}* para #{args[:sender_user] == args[:trade].buyer ? "vender" : "comprar"} *#{args[:trade].item}* foi *modificado* !\nVeja aqui as novas informaçoes\n*#{args[:trade].carrefour_unit.name}*\n*#{args[:trade].date.strftime("%d/%m/%Y")}*\n*#{args[:trade].date.strftime("%H:%M")}*\nPode acessar a plataforma para aceitar esssa modificações #{args[:url]}.
      "
    )
  end

  def destroyed_trade(args = {})
    client.messages.create(
      # From is the numero given by Twillo for the whatsapp sandbox
      from: 'whatsapp:+14155238886',
      to: "whatsapp:#{args[:phone]}",
      body: "
        Olà #{args[:receiver_name]},\nInfelizmente o seu agendamento da 2ª Mão Point Carrefour com *#{args[:sender_user].first_name}* para #{args[:sender_user] == args[:trade].buyer ? "vender" : "comprar"} *#{args[:trade].item}* foi *cancelado* !\n*#{args[:trade].carrefour_unit.name}*\n*#{args[:trade].date.strftime("%d/%m/%Y")}*\n*#{args[:trade].date.strftime("%H:%M")}*\n2mao point fica a disposição para os suas próximas transações !
      "
    )
  end

  def confirmed_trade(args={})
    client.messages.create(
      # From is the numero given by Twillo for the whatsapp sandbox
      from: 'whatsapp:+14155238886',
      to: "whatsapp:#{args[:phone]}",
      body: "
        Olà #{args[:receiver_name]},\nO seu agendamento da 2ª Mão Point Carrefour com *#{args[:sender_user].first_name}* para #{args[:sender_user] == args[:trade].buyer ? "vender" : "comprar"} *#{args[:trade].item}* foi *confirmado* !\n*#{args[:trade].carrefour_unit.name}*\n*#{args[:trade].date.strftime("%d/%m/%Y")}*\n*#{args[:trade].date.strftime("%H:%M")}*\n2mao point fica a disposição para os suas próximas transações !
      "
    )
  end

  private

  def account_sid
    Rails.application.credentials.twillio[:account_sid]
  end

  def auth_token
    Rails.application.credentials.twillio[:auth_token]
  end
end