class AddAmountToAmortizationSchedules < ActiveRecord::Migration[5.1]
  def change
    add_column :amortization_schedules, :amount, :decimal
  end
end
