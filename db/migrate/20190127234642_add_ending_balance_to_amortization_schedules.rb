class AddEndingBalanceToAmortizationSchedules < ActiveRecord::Migration[5.2]
  def change
    add_column :amortization_schedules, :ending_balance, :decimal, default: 0, null: false
  end
end
