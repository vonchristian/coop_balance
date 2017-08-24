class CreateLoanAdditionalCharges < ActiveRecord::Migration[5.1]
  def change
    create_table :loan_additional_charges, id: :uuid do |t|
    	t.belongs_to :loan, foreign_key: true, type: :uuid
      t.string :name
      t.decimal :amount
      t.belongs_to :credit_account, foreign_key: { to_table: :accounts }, type: :uuid
      t.belongs_to :debit_account, foreign_key: { to_table: :accounts }, type: :uuid

      t.timestamps
    end
  end
end
