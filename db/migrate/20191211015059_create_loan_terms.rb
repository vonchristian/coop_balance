class CreateLoanTerms < ActiveRecord::Migration[6.0]
  def change
    create_table :loan_terms, id: :uuid do |t|
      t.belongs_to :loan, null: false, foreign_key: true, type: :uuid
      t.belongs_to :term, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
