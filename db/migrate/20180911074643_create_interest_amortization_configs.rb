class CreateInterestAmortizationConfigs < ActiveRecord::Migration[5.2]
  def change
    create_table :interest_amortization_configs, id: :uuid do |t|
      t.integer :amortization_type
      t.string :description

      t.timestamps
    end
    add_index :interest_amortization_configs, :amortization_type
  end
end
