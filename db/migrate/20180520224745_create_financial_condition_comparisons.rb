class CreateFinancialConditionComparisons < ActiveRecord::Migration[5.2]
  def change
    create_table :financial_condition_comparisons, id: :uuid do |t|
      t.datetime :first_date
      t.datetime :second_date
      t.integer :comparison_type

      t.timestamps
    end
    add_index :financial_condition_comparisons, :comparison_type
  end
end
