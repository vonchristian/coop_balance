class RemoveHasPredeductedInterestFromAmortizationSchedules < ActiveRecord::Migration[5.2]
  def change
    remove_column :amortization_schedules, :has_prededucted_interest, :boolean
  end
end
