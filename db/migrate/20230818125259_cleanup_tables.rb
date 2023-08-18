class CleanupTables < ActiveRecord::Migration[7.0]
  def up
    remove_foreign_key :entries, column: :official_receipt_id
    drop_table :member_accounts
    drop_table :quotes
    drop_table :taggings
    drop_table :tags
    drop_table :wallets
    drop_table :deactivations
    drop_table :account_scopes
    drop_table :income_sources
    drop_table :income_source_categories
    drop_table :invoices
    drop_table :leads
    drop_table :member_occupations
    drop_table :occupations
    drop_table :official_receipts
    drop_table :ownerships
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
