class AddMinimumLoanableAmountToLoanProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :loan_products, :minimum_loanable_amount, :decimal
    add_column :loan_products, :depends_on_share_capital_balance, :string
    add_column :loan_products, :minimum_share_capital_balance, :decimal
    add_column :loan_products, :maximum_share_capital_balance, :decimal
  end
end
