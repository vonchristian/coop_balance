class AddHasClosingAccountFeeToShareCapitalProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :share_capital_products, :has_closing_account_fee, :boolean, default: false
    add_column :share_capital_products, :closing_account_fee, :decimal, default: 0
    add_reference :share_capital_products, :closing_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
