class RenamePaidUpAccountToEquityAccountInShareCapitalProducts < ActiveRecord::Migration[5.2]
  def change
    rename_column :share_capital_products, :paid_up_account_id, :equity_account_id
  end
end
