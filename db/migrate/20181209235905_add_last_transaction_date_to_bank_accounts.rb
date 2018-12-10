class AddLastTransactionDateToBankAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :bank_accounts, :last_transaction_date, :datetime
  end
end
