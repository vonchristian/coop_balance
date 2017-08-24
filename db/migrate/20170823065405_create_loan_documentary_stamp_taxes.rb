class CreateLoanDocumentaryStampTaxes < ActiveRecord::Migration[5.1]
  def change
    create_table :loan_documentary_stamp_taxes, id: :uuid do |t|
      t.belongs_to :loan, foreign_key: true, type: :uuid
      t.decimal :amount

      t.timestamps
    end
  end
end
