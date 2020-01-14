class AddLoanAgingGroupToLoans < ActiveRecord::Migration[6.0]
  def change
    add_reference :loans, :loan_aging_group, foreign_key: true, type: :uuid 
  end
end
