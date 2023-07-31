class CreateAccountRunningBalances < ActiveRecord::Migration[6.1]
  def change
    create_table :account_running_balances, id: :uuid do |t|
      t.belongs_to :entry, null: false, foreign_key: true, type: :uuid
      t.belongs_to :account, null: false, foreign_key: true, type: :uuid
      t.date :entry_date
      t.datetime :entry_time
      t.integer :amount_cents, limit: 8
      t.timestamps
    end

    add_index :account_running_balances, [:account_id, :entry_id], unique: true
  end
end
