class CreateAmounts < ActiveRecord::Migration[5.1]
  def change
    create_table :amounts, id: :uuid do |t|
      t.belongs_to :account, foreign_key: true, type: :uuid
      t.belongs_to :entry, foreign_key: true, type: :uuid
      t.decimal :amount, precision: 20, scale: 20
      t.string :type

      t.timestamps
    end
    add_index :amounts, :type
    add_index :amounts, [:account_id, :entry_id]
    add_index :amounts, [:entry_id, :account_id]
  end
end
