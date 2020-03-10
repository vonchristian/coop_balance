class AddInterestAmortizationToLoanProduct < ActiveRecord::Migration[6.0]
  def change
    add_reference :loan_products, :interest_amortization,  foreign_key: true, type: :uuid 
  end
end
