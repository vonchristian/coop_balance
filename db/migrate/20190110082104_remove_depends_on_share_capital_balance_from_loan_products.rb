class RemoveDependsOnShareCapitalBalanceFromLoanProducts < ActiveRecord::Migration[5.2]
  def change
    remove_column :loan_products, :depends_on_share_capital_balance, :boolean
    remove_column :loan_products, :minimum_share_capital_balance, :decimal
    remove_column :loan_products, :maximum_share_capital_balance, :decimal
  end
end
