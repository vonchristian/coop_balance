class AddMaturityDateToLoanTerms < ActiveRecord::Migration[5.2]
  def change
    add_column :loan_terms, :maturity_date, :datetime
  end
end
