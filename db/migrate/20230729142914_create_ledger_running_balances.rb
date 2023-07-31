class CreateLedgerRunningBalances < ActiveRecord::Migration[6.1]
  def change
    create_table :ledger_running_balances, id: :uuid do |t|
      t.belongs_to :entry, foreign_key: true, type: :uuid
      t.belongs_to :ledger, null: false, foreign_key: true, type: :uuid
      t.date :entry_date, null: false 
      t.datetime :entry_time, null: false 
      t.integer :amount_cents, limit: 8
      t.timestamps
    end

    add_index :ledger_running_balances, [:ledger_id, :entry_id], unique: true
  end
end
