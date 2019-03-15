class AddInterestAmortizationScopeOnAmortizationTypes < ActiveRecord::Migration[5.2]
  def change
    add_column :amortization_types, :interest_amortization_scope, :integer
  end
end
