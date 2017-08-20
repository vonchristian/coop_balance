class CreateCharges < ActiveRecord::Migration[5.1]
  def change
    create_table :charges, id: :uuid do |t|
      t.string :name
      t.belongs_to :credit_account, foreign_key: { to_table: :accounts }, type: :uuid
      t.belongs_to :debit_account, foreign_key:  { to_table: :accounts }, type: :uuid
      t.integer :charge_type
      t.decimal :amount
      t.decimal :percent

      t.timestamps
    end
    add_index :charges, :charge_type
  end
end
