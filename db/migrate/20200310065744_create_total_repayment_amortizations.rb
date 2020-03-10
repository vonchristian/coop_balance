class CreateTotalRepaymentAmortizations < ActiveRecord::Migration[6.0]
  def change
    create_table :total_repayment_amortizations, id: :uuid do |t|
      t.integer :calculation_type, null: false 
    end
    add_index :total_repayment_amortizations, :calculation_type
  end
end
