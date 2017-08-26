class AddTypeToAmortizationSchedules < ActiveRecord::Migration[5.1]
  def change
    add_column :amortization_schedules, :type, :string
    add_index :amortization_schedules, :type
  end
end
