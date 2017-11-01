class AddAccountToLoanProtectionFunds < ActiveRecord::Migration[5.1]
  def change
    add_reference :loan_protection_funds, :account, foreign_key: true, type: :uuid
  end
end
