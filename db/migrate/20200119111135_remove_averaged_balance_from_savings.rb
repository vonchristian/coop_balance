class RemoveAveragedBalanceFromSavings < ActiveRecord::Migration[6.0]
  def change

    remove_column :savings, :averaged_balance, :decimal
  end
end
