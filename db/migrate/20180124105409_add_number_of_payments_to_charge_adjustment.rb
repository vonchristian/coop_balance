class AddNumberOfPaymentsToChargeAdjustment < ActiveRecord::Migration[5.1]
  def change
    add_column :charge_adjustments, :number_of_payments, :integer
  end
end