class AddInterestToAmortizationSchedules < ActiveRecord::Migration[5.2]
  def change
    add_column :amortization_schedules, :interest, :decimal, default: 0
  end
end
