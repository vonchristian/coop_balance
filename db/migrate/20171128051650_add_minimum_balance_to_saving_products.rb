class AddMinimumBalanceToSavingProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :saving_products, :minimum_balance, :decimal
  end
end
