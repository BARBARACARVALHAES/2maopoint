class AddQrCodeToTrades < ActiveRecord::Migration[6.1]
  def change
    add_column :trades, :qr_code, :text
  end
end
