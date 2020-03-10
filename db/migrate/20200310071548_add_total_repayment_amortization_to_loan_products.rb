class AddTotalRepaymentAmortizationToLoanProducts < ActiveRecord::Migration[6.0]
  def change
    add_reference :loan_products, :total_repayment_amortization, foreign_key: true, type: :uuid 
  end
end
