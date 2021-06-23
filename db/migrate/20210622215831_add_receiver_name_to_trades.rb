class AddReceiverNameToTrades < ActiveRecord::Migration[6.1]
  def change
    add_column :trades, :receiver_name, :string
  end
end
