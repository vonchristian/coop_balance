class RemoveInterestFromAmortizationSchedules < ActiveRecord::Migration[5.2]
  def change
    remove_column :amortization_schedules, :interest, :decimal
  end
end
