class DropTableAccountingReportAccountCategories < ActiveRecord::Migration[6.0]
  def up
    drop_table :accounting_report_account_categories
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
