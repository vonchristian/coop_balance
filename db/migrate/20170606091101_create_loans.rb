class CreateLoans < ActiveRecord::Migration[5.1]
  def change
    create_table :loans, id: :uuid do |t|
      t.belongs_to :member, foreign_key: true, type: :uuid
      t.belongs_to :loan_product, foreign_key: true, type: :uuid
      t.decimal :loan_amount
      t.decimal :loan_term
      t.integer :mode_of_payment
      t.datetime :application_date

      t.timestamps
    end
  end
end
