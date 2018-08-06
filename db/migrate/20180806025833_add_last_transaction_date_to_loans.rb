class AddLastTransactionDateToLoans < ActiveRecord::Migration[5.2]
  def change
    add_column :loans, :last_transaction_date, :datetime
  end
end
