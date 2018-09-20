class CreateLoanApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :loan_applications, id: :uuid do |t|
      t.references :borrower, polymorphic: true, type: :uuid
      t.integer :term
      t.decimal :loan_amount
      t.datetime :application_date
      t.integer :mode_of_payment
      t.string :account_number
      t.belongs_to :preparer, foreign_key: { to_table: :users }, type: :uuid
      t.belongs_to :cooperative, foreign_key: true, type: :uuid
      t.belongs_to :loan_product, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
