class AddAmountToAmounts < ActiveRecord::Migration[5.1]
  def change
    add_column :amounts, :amount, :decimal
  end
end
