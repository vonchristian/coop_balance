class AddLastTransactionDateToSavings < ActiveRecord::Migration[5.2]
  def change
    add_column :savings, :last_transaction_date, :datetime
  end
end
