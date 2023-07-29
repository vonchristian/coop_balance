class CreateOfficeLedgers < ActiveRecord::Migration[6.1]
  def change
    create_table :office_ledgers, id: :uuid do |t|
      t.belongs_to :office, null: false, foreign_key: true, type: :uuid
      t.belongs_to :ledger, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_index :office_ledgers, [:office_id, :ledger_id], unique: true
  end
end
