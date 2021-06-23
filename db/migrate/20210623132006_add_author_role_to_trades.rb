class AddAuthorRoleToTrades < ActiveRecord::Migration[6.1]
  def change
    add_column :trades, :author_role, :string
  end
end
