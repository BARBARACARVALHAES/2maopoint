class AddAuthorIdToTrades < ActiveRecord::Migration[6.1]
  def change
    add_column :trades, :author_id, :integer
  end
end
