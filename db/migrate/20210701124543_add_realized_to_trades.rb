class AddRealizedToTrades < ActiveRecord::Migration[6.1]
  def change
    add_column :trades, :realized, :boolean
  end
end
