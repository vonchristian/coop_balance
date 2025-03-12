class CreateAccountingReportAccountCategorizations < ActiveRecord::Migration[6.0]
  def change
    create_table :accounting_report_account_categorizations, id: :uuid do |t|
      t.belongs_to :accounting_report, null: false, foreign_key: true, type: :uuid, index: { name: 'index_accounting_report_on_acc_report_categorizations' }
      t.references :account_category, polymorphic: true, null: false, type: :uuid, index: { name: 'index_accounting_category_on_acc_report_categorizations' }

      t.timestamps
    end
  end
end
