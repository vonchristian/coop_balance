class CreateLoanDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :loan_discounts, id: :uuid do |t|
      t.belongs_to :loan, foreign_key: true, type: :uuid
      t.datetime :date
      t.integer :discount_type, index: true
      t.text :description
      t.belongs_to :computed_by, foreign_key: { to_table: :users }, type: :uuid
      t.decimal :amount

      t.timestamps
    end
  end
end
