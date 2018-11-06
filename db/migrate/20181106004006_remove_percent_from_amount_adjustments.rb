class RemovePercentFromAmountAdjustments < ActiveRecord::Migration[5.2]
  def change
    remove_column :amount_adjustments, :percent, :decimal
  end
end
