class AddHasMinimumBalanceToShareCapitals < ActiveRecord::Migration[5.2]
  def change
    add_column :share_capitals, :has_minimum_balance, :boolean, default: false
  end
end
