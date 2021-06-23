class TradeMailer < ApplicationMailer
  def created_trade
    @receiver_email = params[:receiver_email]
    @sender_user = params[:sender_user]
    @trade = params[:trade]
    @user = User.find_by(email: @receiver_email)
    @url = @user ? profile_url(user) : new_user_registration_url
    mail(to: @receiver_email, subject: 'Novo agendamento do 2a-Mao')
  end
end
