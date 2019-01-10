class CreateAmortizationTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :amortization_types, id: :uuid do |t|
      t.string :name
      t.string :description
      t.integer :amortization_type

      t.timestamps
    end
    add_index :amortization_types, :amortization_type
  end
end
