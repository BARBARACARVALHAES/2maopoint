class AddColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :cpf, :string
    add_column :users, :birthdate, :date
    add_column :users, :phone, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
  end
end
