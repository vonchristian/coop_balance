class CreateLoans < ActiveRecord::Migration[5.1]
  def change
    create_table :loans, id: :uuid do |t|
      t.belongs_to :member, foreign_key: true, type: :uuid
      t.belongs_to :loan_product, foreign_key: true, type: :uuid
      t.decimal :loan_amount, precision: 20, scale: 20
      t.datetime :application_date

      t.timestamps
    end
  end
end
