class RemoveHasLoanProtectionFundFromLoanProducts < ActiveRecord::Migration[5.2]
  def change
    remove_column :loan_products, :has_loan_protection_fund, :boolean
  end
end
