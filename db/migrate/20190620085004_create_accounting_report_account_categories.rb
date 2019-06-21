class CreateAccountingReportAccountCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :accounting_report_account_categories, id: :uuid do |t|
      t.belongs_to :accounting_report, foreign_key: true, type: :uuid, index: { name: 'index_account_report_on_accounting_join_categories' }
      t.belongs_to :account_category, foreign_key: true, type: :uuid, index:  { name: 'index_account_category_on_accounting_join_categories' }

      t.timestamps
    end
  end
end
