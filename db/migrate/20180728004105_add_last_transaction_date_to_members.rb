class AddLastTransactionDateToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :last_transaction_date, :datetime
  end
end
