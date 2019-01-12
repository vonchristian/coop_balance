class CreateInterestPredeductions < ActiveRecord::Migration[5.2]
  def change
    create_table :interest_predeductions, id: :uuid do |t|
      t.belongs_to :loan_product, foreign_key: true, type: :uuid
      t.integer :calculation_type
      t.decimal :rate
      t.decimal :amount
      t.integer :number_of_payments

      t.timestamps
    end
    add_index :interest_predeductions, :calculation_type
  end
end
