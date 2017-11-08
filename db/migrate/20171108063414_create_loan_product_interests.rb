class CreateLoanProductInterests < ActiveRecord::Migration[5.1]
  def change
    create_table :loan_product_interests, id: :uuid do |t|
      t.decimal :rate
      t.belongs_to :loan_product, foreign_key: true, type: :uuid
      t.belongs_to :account, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
