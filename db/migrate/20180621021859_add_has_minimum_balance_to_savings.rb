class AddHasMinimumBalanceToSavings < ActiveRecord::Migration[5.2]
  def change
    add_column :savings, :has_minimum_balance, :boolean, default: false
  end
end
