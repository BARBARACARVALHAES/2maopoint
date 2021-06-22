class ChangeColumnsFromTrades < ActiveRecord::Migration[6.1]
  def change
    change_column :trades, :item_category_id, :integer, null: true
    change_column :trades, :carrefour_unit_id, :integer, null: true
  end
end
