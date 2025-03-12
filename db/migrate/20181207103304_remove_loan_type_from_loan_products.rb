class RemoveLoanTypeFromLoanProducts < ActiveRecord::Migration[5.2]
  def change
    remove_column :loan_products, :loan_type, :integer
  end
end
