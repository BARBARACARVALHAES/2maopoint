require 'rails_helper'

RSpec.feature "Trades", type: :feature, js: true do
  let(:user) { create(:user) }
  let(:trade_location) { create(:trade_location) }
  let(:trade_invitation) { create(:trade_invitation) }
  let(:item_categories) { create_list(:item_category, 5) }
  let(:carrefour_units) { create_list(:carrefour_unit, 5) }

  context 'Unlogged' do
    scenario 'get redirect to sign_in' do
      visit(new_trade_path)
      expect(page).to have_current_path(new_user_session_path)
    end
  end

  context 'Logged' do
    before do
      login_as(user)
    end

    scenario 'Can access new page and redirect to wizard' do
      expect { visit(new_trade_path) }.to change(Trade, :count).by(1)
      trade = Trade.last
      expect(page).to have_current_path(trade_step_path(trade, 'infos'))
    end

    scenario 'infos' do
      # Create item categories
      item_categories
      visit(new_trade_path)
      choose('trade_author_role_vendedor')
      find('#trade_item_category_id').find(:xpath, 'option[2]').select_option
      fill_in('trade_item', with: 'Test item')
      click_on(id: 'avançar')
      expect(Trade.all.order(updated_at: :desc).first.item).to eq("Test item")
    end

    scenario 'location' do
      # Create carrefour units
      carrefour_units
      visit(trade_step_path(trade_location, "location"))
      fill_in('trade_buyer_cep', with: '22000-111')
      fill_in('trade_seller_cep', with: '22000-112')
      find('#trade_carrefour_unit_id').find(:xpath, 'option[2]').select_option
      click_on(id: 'avançar')
      expect(Trade.all.order(updated_at: :desc).first.buyer_cep).to eq("22000-111")
    end

    scenario 'invitation' do
      visit(trade_step_path(trade_invitation, "invitation"))
      fill_in('trade_receiver_email', with: 'test@test.com')
      click_on(id: 'terminar')
      expect(Trade.all.order(updated_at: :desc).first.receiver_email).to eq("test@test.com")
    end
  end
end

