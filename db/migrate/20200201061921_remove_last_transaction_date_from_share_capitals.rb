class RemoveLastTransactionDateFromShareCapitals < ActiveRecord::Migration[6.0]
  def change
    remove_column :share_capitals, :last_transaction_date, :datetime
  end
end
