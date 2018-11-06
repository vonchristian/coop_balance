class AddAdjustmentTypeToAmountAdjustments < ActiveRecord::Migration[5.2]
  def change
    add_column :amount_adjustments, :adjustment_type, :integer
    add_index :amount_adjustments, :adjustment_type
  end
end
