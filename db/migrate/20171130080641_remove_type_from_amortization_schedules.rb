class RemoveTypeFromAmortizationSchedules < ActiveRecord::Migration[5.1]
  def change
    remove_index :amortization_schedules, :type
    remove_column :amortization_schedules, :type, :string
    remove_column :amortization_schedules, :amortizeable_id, :integer
    remove_column :amortization_schedules, :amortizeable_type, :string
    remove_column :amortization_schedules, :schedule_type, :integer
  end
end
