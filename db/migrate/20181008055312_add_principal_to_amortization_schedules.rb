class AddPrincipalToAmortizationSchedules < ActiveRecord::Migration[5.2]
  def change
    add_column :amortization_schedules, :principal, :decimal, default: 0
  end
end
