class AddClosingAccountFeeToSavingProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :saving_products, :closing_account_fee, :decimal, default: 0
  end
end
