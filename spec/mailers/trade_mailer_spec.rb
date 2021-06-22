require "rails_helper"

RSpec.describe TradeMailer, type: :mailer do
  let(:user) { create(:user) }

  it '#created_trade' do
    mailer = described_class.with(user: user).created_trade
    expect(mailer.to).to eq([user.email])
  end
end
