class AddMinimumBalanceToSavingProductInterestConfigs < ActiveRecord::Migration[6.0]
  def change
    add_column :saving_product_interest_configs, :minimum_balance, :decimal
  end
end
