class CreateTrades < ActiveRecord::Migration[6.1]
  def change
    create_table :trades do |t|
      t.integer :buyer_id
      t.integer :seller_id
      t.references :carrefour_unit, null: false, foreign_key: true
      t.references :item_category, null: false, foreign_key: true
      t.datetime :date
      t.string :item
      t.boolean :buyer_accepted, default: false
      t.boolean :seller_accepted, default: false
      t.string :buyer_cep
      t.string :seller_cep
      t.string :receiver_email

      t.timestamps
    end
  end
end
