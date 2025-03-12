class AddActiveToLoanProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :loan_products, :active, :boolean, default: true
  end
end
