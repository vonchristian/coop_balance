class RemovePenaltyAcountFromLoanProducts < ActiveRecord::Migration[5.1]
  def change
    remove_reference :loan_products, :penalty_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
