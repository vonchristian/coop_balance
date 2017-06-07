class RemoveAmountFromAmounts < ActiveRecord::Migration[5.1]
  def change
    remove_column :amounts, :amount, :decimal
  end
end
