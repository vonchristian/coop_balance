class AddTotalToAmortizationSchedules < ActiveRecord::Migration[5.2]
  def change
    add_column :amortization_schedules, :total_repayment, :decimal
  end
end
