class ChangeLoanApplicationLoanAmountToMonetize < ActiveRecord::Migration[5.2]
  def change
    change_table :loan_applications do |t|
      t.monetize :loan_amount
    end
  end
end
