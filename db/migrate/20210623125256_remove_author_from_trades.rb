class RemoveAuthorFromTrades < ActiveRecord::Migration[6.1]
  def change
    remove_column :trades, :author, :string
  end
end
