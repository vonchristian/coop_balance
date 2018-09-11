class AddInterestAmortizationConfigToCooperatives < ActiveRecord::Migration[5.2]
  def change
    add_reference :cooperatives, :interest_amortization_config, foreign_key: true, type: :uuid
  end
end
