class CreateAccountReceivableStores < ActiveRecord::Migration[5.1]
  def change
    create_table :account_receivable_stores, id: :uuid do |t|
      t.references :debtor, polymorphic: true, type: :uuid, index: {name: "index_borrower_account_receivable_store" }
      t.belongs_to :account, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
