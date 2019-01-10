class AddAmortizationTypeToLoanProduct < ActiveRecord::Migration[5.2]
  def change
    add_reference :loan_products, :amortization_type, foreign_key: true, type: :uuid
  end
end
