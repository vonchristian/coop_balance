class RemoveLoanProtectionFundFromAmortizationSchedules < ActiveRecord::Migration[5.1]
  def change
    remove_column :amortization_schedules, :loan_protection_fund, :decimal
  end
end
