class AddHasPredeductedInterestToAmortizationSchedules < ActiveRecord::Migration[5.2]
  def change
    add_column :amortization_schedules, :has_prededucted_interest, :boolean
  end
end
