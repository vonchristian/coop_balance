class AddMaxLoanableAmountToLoanProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :loan_products, :max_loanable_amount, :decimal
    add_column :loan_products, :loan_product_term, :decimal
    add_column :loan_products, :mode_of_payment, :integer
  end
end
