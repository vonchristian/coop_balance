class AddLastTransactionDateToShareCapitals < ActiveRecord::Migration[5.2]
  def change
    add_column :share_capitals, :last_transaction_date, :datetime
  end
end
