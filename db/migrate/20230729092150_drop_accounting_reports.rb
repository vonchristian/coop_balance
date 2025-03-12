class DropAccountingReports < ActiveRecord::Migration[6.1]
  def up
    drop_table :accounting_reports
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
