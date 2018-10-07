class AddForwardedLoanToLoans < ActiveRecord::Migration[5.2]
  def change
    add_column :loans, :forwarded_loan, :boolean, default: false
  end
end
