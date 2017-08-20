class CreateLoanProductCharges < ActiveRecord::Migration[5.1]
  def change
    create_table :loan_product_charges, id: :uuid do |t|
      t.belongs_to :charge, foreign_key: true,  type: :uuid
      t.belongs_to :loan_product, foreign_key: true,  type: :uuid

      t.timestamps
    end
  end
end
