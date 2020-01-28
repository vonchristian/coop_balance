FactoryBot.define do
  factory :accounting_report_account_categorization, class: AccountingModule::AccountingReportAccountCategorization do
    accounting_report { nil }
    account_category { nil }
  end
end
