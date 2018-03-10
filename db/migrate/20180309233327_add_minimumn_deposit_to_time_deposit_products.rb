class AddMinimumnDepositToTimeDepositProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :time_deposit_products, :minimum_deposit, :decimal
    add_column :time_deposit_products, :maximum_deposit, :decimal
  end
end
