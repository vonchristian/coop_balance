class AddAccountNumberToLoans < ActiveRecord::Migration[5.1]
  def change
    add_column :loans, :account_number, :string
    add_index :loans, :account_number, unique: true
  end
end
