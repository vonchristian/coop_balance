class CreateLoanProductTerms < ActiveRecord::Migration[5.1]
  def change
    create_table :loan_product_terms, id: :uuid do |t|
      t.decimal :term
      t.belongs_to :loan_product, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
