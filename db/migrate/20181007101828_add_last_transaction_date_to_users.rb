class AddLastTransactionDateToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :last_transaction_date, :datetime
  end
end
