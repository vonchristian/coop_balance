class CreateUtilityBills < ActiveRecord::Migration[6.0]
  def change
    create_table :utility_bills, id: :uuid do |t|
      t.decimal    :amount
      t.belongs_to :merchant,              null: false, foreign_key: true, type: :uuid 
      t.belongs_to :utility_bill_category, null: false, foreign_key: true, type: :uuid 
      t.belongs_to :payee,                 null: false, polymorphic: true, type: :uuid 
      t.belongs_to :receivable_account,    null: false, foreign_key: { to_table: :accounts }, type: :uuid 

      t.belongs_to :voucher,                foreign_key: true, type: :uuid 
      t.string :description
      t.string :reference_number
      t.datetime :due_date
      t.string :account_number, unique: true 

      t.timestamps
    end
    add_index :utility_bills, :due_date 
    add_index :utility_bills, :account_number 

  end
end
