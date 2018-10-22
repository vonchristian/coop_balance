class AddInterestRateToTimeDepositProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :time_deposit_products, :interest_rate, :decimal
  end
end
