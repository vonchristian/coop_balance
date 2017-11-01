class AddLoanProtectionRateToLoanProtectionFunds < ActiveRecord::Migration[5.1]
  def change
    add_reference :loan_protection_funds, :loan_protection_rate, foreign_key: true, type: :uuid
  end
end
