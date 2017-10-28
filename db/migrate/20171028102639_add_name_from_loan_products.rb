class AddNameFromLoanProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :loan_products, :name, :string
    add_index :loan_products, :name, unique: true
  end
end
