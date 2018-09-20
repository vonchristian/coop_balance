class CreateAmountAdjustments < ActiveRecord::Migration[5.2]
  def change
    create_table :amount_adjustments, id: :uuid do |t|
      t.belongs_to :voucher_amount, foreign_key: true, type: :uuid
      t.belongs_to :loan_application, foreign_key: true, type: :uuid

      t.decimal :amount
      t.decimal :percent
      t.integer :number_of_payments

      t.timestamps
    end
  end
end
