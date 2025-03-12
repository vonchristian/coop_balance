class RemoveLastTransactionDateFromSavings < ActiveRecord::Migration[6.0]
  def change
    remove_column :savings, :last_transaction_date, :datetime
  end
end
