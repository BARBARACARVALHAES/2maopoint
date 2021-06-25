class TradeMailer < ApplicationMailer
  def created_trade
    @receiver_email = params[:receiver_email]
    @receiver_name = params[:receiver_name]
    @sender_user = params[:sender_user]
    @trade = params[:trade]
    @user = User.find_by(email: @receiver_email)
    @url = @user ? confirm_screen_trade_url(@trade) : new_user_registration_url
    mail(to: @receiver_email, subject: 'Novo agendamento do 2ª Mão Point')
  end

  def update_trade
    @receiver_email = params[:receiver_email]
    @receiver_name = params[:receiver_name]
    @sender_user = params[:sender_user]
    @trade = params[:trade]
    @user = User.find_by(email: @receiver_email)
    @url = @user ? confirm_screen_trade_url(@trade) : new_user_registration_url
    mail(to: @receiver_email, subject: 'Reagendamento de encontro no 2ª Mão Point')
  end

end
