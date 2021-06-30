class AddReceiverEmailToTrades < ActiveRecord::Migration[6.1]
  def change
    add_column :trades, :receiver_email, :string
  end
end
