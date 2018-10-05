class RemoveClosingAccountFromShareCapitalProducts < ActiveRecord::Migration[5.2]
  def change
    remove_reference :share_capital_products, :closing_account, foreign_key: {to_table: :accounts}, type: :uuid
    remove_reference :share_capital_products, :interest_payable_account, foreign_key: {to_table: :accounts}, type: :uuid
  end
end
