class RemovePrincipalFromAmortizationSchedules < ActiveRecord::Migration[5.2]
  def change
    remove_column :amortization_schedules, :principal, :decimal
  end
end
