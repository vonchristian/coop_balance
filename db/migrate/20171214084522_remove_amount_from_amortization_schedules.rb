class RemoveAmountFromAmortizationSchedules < ActiveRecord::Migration[5.1]
  def change
    remove_column :amortization_schedules, :amount, :decimal
  end
end
