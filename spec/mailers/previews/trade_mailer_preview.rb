# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class TradeMailerPreview < ActionMailer::Preview
  def created_trade
    TradeMailer.with(user: User.first).created_trade
  end
end
