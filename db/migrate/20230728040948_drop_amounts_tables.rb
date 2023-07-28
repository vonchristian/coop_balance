class DropAmountsTables < ActiveRecord::Migration[6.1]
  def change
    drop_table :debit_amounts, if_exists: true
    drop_table :credit_amounts, if_exists: true
  end
end
