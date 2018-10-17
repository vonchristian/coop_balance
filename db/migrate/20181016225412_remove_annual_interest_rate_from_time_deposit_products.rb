class RemoveAnnualInterestRateFromTimeDepositProducts < ActiveRecord::Migration[5.2]
  def change
    remove_column :time_deposit_products, :annual_interest_rate, :decimal
  end
end
