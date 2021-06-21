class CreateCarrefourUnits < ActiveRecord::Migration[6.1]
  def change
    create_table :carrefour_units do |t|
      t.string :name
      t.string :address
      t.string :cep
      t.string :suburb
      t.string :city

      t.timestamps
    end
  end
end
