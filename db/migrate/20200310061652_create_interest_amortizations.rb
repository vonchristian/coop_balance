class CreateInterestAmortizations < ActiveRecord::Migration[6.0]
  def change
    create_table :interest_amortizations, id: :uuid do |t|
      t.integer :calculation_type, null: false 
    end
    add_index :interest_amortizations, :calculation_type
  end
end
