class AddScheduleTypeToAmortizationSchedules < ActiveRecord::Migration[5.1]
  def change
    add_column :amortization_schedules, :schedule_type, :integer
    add_index :amortization_schedules, :schedule_type
  end
end
