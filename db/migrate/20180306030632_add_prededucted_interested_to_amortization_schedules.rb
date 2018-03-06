class AddPredeductedInterestedToAmortizationSchedules < ActiveRecord::Migration[5.1]
  def change
    add_column :amortization_schedules, :prededucted_interest, :boolean, default: false
  end
end
