class AddAgainInterestPayableAccountToShareCapitalProducts < ActiveRecord::Migration[5.2]
  def change
    add_reference :share_capital_products, :interest_payable_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
