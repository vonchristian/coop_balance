class RenameAmortizationTypeInAmortizationTypes < ActiveRecord::Migration[5.2]
  def change
    rename_column :amortization_types, :amortization_type, :calculation_type
  end
end
