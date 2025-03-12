class DropAccountingReportAccountCategorizations < ActiveRecord::Migration[6.1]
  def up
    drop_table :accounting_report_account_categorizations
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
