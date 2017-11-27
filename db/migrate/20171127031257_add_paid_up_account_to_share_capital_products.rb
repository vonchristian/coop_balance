class AddPaidUpAccountToShareCapitalProducts < ActiveRecord::Migration[5.1]
  def change
    add_reference :share_capital_products, :paid_up_account, foreign_key: { to_table: :accounts }, type: :uuid
    add_reference :share_capital_products, :subscription_account, foreign_key: { to_table: :accounts }, type: :uuid

  end
end
