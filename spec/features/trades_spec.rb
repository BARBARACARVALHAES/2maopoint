require 'rails_helper'

RSpec.feature "Trades", type: :feature, js: true do
  let(:user) { create(:user) }
  let(:trade_location) { create(:trade_location, author: user) }
  let(:trade_carrefour_unit) { create(:trade_carrefour_unit, author: user) }
  let(:trade_invitation) { create(:trade_invitation, author: user) }
  let(:item_categories) { create_list(:item_category, 5) }
  let(:carrefour_units) { create_list(:carrefour_unit, 5) }

  context 'Unlogged' do
    # scenario 'get redirect to sign_in' do
    #   visit(new_trade_path)
    #   expect(page).to have_current_path(new_user_session_path)
    # end
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
      find('#trade_author_role').find(:xpath, 'option[1]').select_option
      find('#trade_item_category_id').find(:xpath, 'option[2]').select_option
      fill_in('trade_item', with: 'Test item')
      click_on(id: 'avançar')
      expect(Trade.all.order(updated_at: :desc).first.item).to eq("Test item")
    end

    scenario 'location' do
      # Create carrefour units
      carrefour_units
      visit(trade_step_path(trade_location, "location"))
      fill_in('trade_seller_cep', with: '')
      fill_in('trade_buyer_cep', with: '')
      fill_in('trade_buyer_cep', with: '22000-111')
      fill_in('trade_seller_cep', with: '22000-112')
      click_on(id: 'avançar')
      expect(Trade.all.order(updated_at: :desc).first.buyer_cep).to eq("22000-111")
      expect(Trade.all.order(updated_at: :desc).first.seller_cep).to eq("22000-112")
    end

    scenario 'carrefour_unit + verify first option with geolocalisation' do
      # Create carrefour units
      carrefour_units
      unit_prox_users = create(:carrefour_unit, {name: 'Test loc', latitude: -23.517391528350526, longitude: -46.644848298459})
      
      trade_carrefour_unit
      visit(trade_step_path(trade_carrefour_unit, "carrefour_unit"))
      find('#trade_carrefour_unit_id').find(:xpath, 'option[2]').select_option
      click_on(id: 'avançar')
      expect(Trade.all.order(updated_at: :desc).first.carrefour_unit).to eq(unit_prox_users)
    end

    scenario 'invitation' do
      visit(trade_step_path(trade_invitation, "invitation"))
      fill_in('trade_receiver_phone', with: '')
      # Com a mascara ele espere um espaço na frente
      fill_in('trade_receiver_phone', with: ' 21999999999')
      fill_in('trade_receiver_name', with: 'name Test')
      click_on(id: 'terminar')
      expect(Trade.all.order(updated_at: :desc).first.receiver_phone).to eq("21999999999")
      expect(Trade.all.order(updated_at: :desc).first.receiver_name).to eq("name Test")
    end

    scenario 'flatpickr works !' do
      # Create carrefour units
      carrefour_units
      visit(trade_step_path(trade_location, "location"))
      # complete the flatpickr date
      page.execute_script("document.querySelector('#flat_datetime').value = '2021-12-12 11:00'")
      click_on(id: 'avançar')
      expect(Trade.all.order(updated_at: :desc).first.date.strftime('%d/%m/%y - %H:%M')).to eq("12/12/21 - 11:00")
    end
  end
end

