class AddOptinToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :optin_ads, :boolean
    add_column :users, :optin_privacy, :boolean
  end
end
