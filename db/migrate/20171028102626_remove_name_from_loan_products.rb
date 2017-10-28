class RemoveNameFromLoanProducts < ActiveRecord::Migration[5.1]
  def change
    remove_column :loan_products, :name, :string
  end
end
