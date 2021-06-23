require 'rails_helper'

RSpec.feature "Trades", type: :feature, js: true do
  let(:user) { create(:user) }

  context 'Trades new' do
    before do
      login_as(user)
    end

    scenario 'Can access new page and redirect to wizard' do
      expect { visit(new_trade_path) }.to change(Trade, :count).by(1)
      trade = Trade.last
      expect(page).to have_current_path(trade_step_path(trade, 'infos'))
    end

    scenario 'User complete all the form' do
      visit(new_trade_path)
      trade = Trade.last
      check('trade_author_role_vendedor')
      fill('')
    end
  end
end
