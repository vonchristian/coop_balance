class AddInterestRateFromTimeDepositProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :time_deposit_products, :annual_interest_rate, :decimal
  end
end
