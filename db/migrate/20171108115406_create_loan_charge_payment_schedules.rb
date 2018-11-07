class CreateLoanChargePaymentSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :loan_charge_payment_schedules, id: :uuid do |t|
      t.integer :schedule_type
      t.datetime :date
      t.decimal :amount

      t.timestamps
    end
    add_index :loan_charge_payment_schedules, :schedule_type
  end
end
