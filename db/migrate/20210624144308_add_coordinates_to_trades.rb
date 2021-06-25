class AddCoordinatesToTrades < ActiveRecord::Migration[6.1]
  def change
    add_column :trades, :lat_buyer, :float
    add_column :trades, :long_buyer, :float
    add_column :trades, :lat_seller, :float
    add_column :trades, :long_seller, :float
  end
end
