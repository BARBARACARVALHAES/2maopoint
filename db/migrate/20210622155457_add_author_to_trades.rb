class AddAuthorToTrades < ActiveRecord::Migration[6.1]
  def change
    add_column :trades, :author, :string
  end
end
