class AddPaymentCalculationTypeToAmortizationTypes < ActiveRecord::Migration[5.2]
  def change
    add_column :amortization_types, :repayment_calculation_type, :integer
    add_index :amortization_types, :repayment_calculation_type
  end
end
