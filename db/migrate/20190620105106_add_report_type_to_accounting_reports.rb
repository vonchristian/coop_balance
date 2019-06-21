class AddReportTypeToAccountingReports < ActiveRecord::Migration[5.2]
  def change
    add_column :accounting_reports, :report_type, :integer
    add_index :accounting_reports, :report_type
  end
end
