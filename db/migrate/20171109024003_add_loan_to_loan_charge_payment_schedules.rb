class AddLoanToLoanChargePaymentSchedules < ActiveRecord::Migration[5.1]
  def change
    add_reference :loan_charge_payment_schedules, :loan, foreign_key: true, type: :uuid
  end
end
