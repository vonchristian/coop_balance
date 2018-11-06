class AddRateToAmountAdjustments < ActiveRecord::Migration[5.2]
  def change
    add_column :amount_adjustments, :rate, :decimal
  end
end
