class ChangeReceiverNumberToReceiverPhone < ActiveRecord::Migration[6.1]
  def change
    rename_column :trades, :receiver_email, :receiver_phone
  end
end
