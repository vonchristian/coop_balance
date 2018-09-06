class AddLastTransactionDateToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :last_transaction_date, :datetime
  end
end
