class AddAccountNumberToProgramSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :program_subscriptions, :account_number, :string
    add_index :program_subscriptions, :account_number, unique: true
  end
end
