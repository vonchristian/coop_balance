class CreateAccountingReports < ActiveRecord::Migration[5.2]
  def change
    create_table :accounting_reports, id: :uuid do |t|
      t.string :title, null: false
      t.belongs_to :office, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
