class AddLoanTypeToLoanProducts < ActiveRecord::Migration[5.2]
  def change
  	add_column :loan_products, :loan_type, :integer
  end
end
