class CreateLoanProtectionFunds < ActiveRecord::Migration[5.1]
  def change
    create_table :loan_protection_funds, id: :uuid do |t|
      t.belongs_to :loan, foreign_key: true, type: :uuid
      t.decimal :rate
      t.decimal :amount

      t.timestamps
    end
  end
end
