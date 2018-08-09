class AddPaymentStatusToAmortizationSchedules < ActiveRecord::Migration[5.2]
  def change
    add_column :amortization_schedules, :payment_status, :integer
    add_index :amortization_schedules, :payment_status
  end
end
