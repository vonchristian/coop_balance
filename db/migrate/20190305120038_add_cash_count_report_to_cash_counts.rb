class AddCashCountReportToCashCounts < ActiveRecord::Migration[5.2]
  def change
    add_reference :cash_counts, :cash_count_report, foreign_key: true, type: :uuid
  end
end
