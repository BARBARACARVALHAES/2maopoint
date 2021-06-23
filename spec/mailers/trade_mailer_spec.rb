require "rails_helper"

RSpec.describe TradeMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:trade) { create(:trade) }

  it '#created_trade' do
    mailer = described_class.with(sender_user: user, receiver_email: 'testdoemail@email.com', trade: trade).created_trade
    expect(mailer.to).to eq(['testdoemail@email.com'])
    expect(mailer.from).to eq([ApplicationMailer::CONTACT_MAIL])
  end
end
