class TradeMailer < ApplicationMailer
  def created_trade
    @user = params[:user]
    mail(to: @user.email, subject: 'Novo agendamento do 2a-Mao')
  end
end
