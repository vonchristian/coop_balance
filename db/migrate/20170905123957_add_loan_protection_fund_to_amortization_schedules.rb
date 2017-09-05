class AddLoanProtectionFundToAmortizationSchedules < ActiveRecord::Migration[5.1]
  def change
    add_column :amortization_schedules, :loan_protection_fund, :decimal
  end
end
