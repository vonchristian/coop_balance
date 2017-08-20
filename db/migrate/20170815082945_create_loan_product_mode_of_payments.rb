class CreateLoanProductModeOfPayments < ActiveRecord::Migration[5.1]
  def change
    create_table :loan_product_mode_of_payments, id: :uuid do |t|
      t.belongs_to :loan_product, foreign_key: true, type: :uuid
      t.belongs_to :mode_of_payment, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
