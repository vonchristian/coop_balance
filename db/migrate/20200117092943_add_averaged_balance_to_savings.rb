class AddAveragedBalanceToSavings < ActiveRecord::Migration[6.0]
  def change
    add_column :savings, :averaged_balance, :decimal, default: 0
  end
end
