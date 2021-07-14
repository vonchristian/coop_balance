class CreateCreditAmounts < ActiveRecord::Migration[6.0]
  def change
    create_table :credit_amounts, id: :uuid do |t|
      t.belongs_to :old_credit_amount, foreign_key: { to_table: :amounts }, type: :uuid
      t.integer :amount_cents, scale: 8
      t.references :account, polymorphic: true, null: false, type: :uuid
      t.belongs_to :entry, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
