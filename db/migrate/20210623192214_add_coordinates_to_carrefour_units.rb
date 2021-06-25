class AddCoordinatesToCarrefourUnits < ActiveRecord::Migration[6.1]
  def change
    add_column :carrefour_units, :latitude, :float
    add_column :carrefour_units, :longitude, :float
  end
end
