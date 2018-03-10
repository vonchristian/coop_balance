class RemoveMinimumAmountFromTimeDepositProducts < ActiveRecord::Migration[5.1]
  def change
    remove_column :time_deposit_products, :minimum_amount, :decimal
    remove_column :time_deposit_products, :maximum_amount, :decimal
  end
end
