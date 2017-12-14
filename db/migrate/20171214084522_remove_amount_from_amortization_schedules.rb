class RemoveAmountFromAmortizationSchedules < ActiveRecord::Migration[5.2]
  def change
    remove_column :amortization_schedules, :amount, :decimal
  end
end
