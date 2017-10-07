class CreateLoanCharges < ActiveRecord::Migration[5.1]
  def change
    create_table :loan_charges, id: :uuid do |t|
      t.belongs_to :loan, foreign_key: true, type: :uuid
      t.belongs_to :charge, foreign_key: true, type: :uuid
      t.boolean :optional

      t.timestamps
    end
  end
end