module AccountingModule
  class AccountingReportAccountCategory < ApplicationRecord
    belongs_to :accounting_report, class_name: 'AccountingModule::AccountingReport'
    belongs_to :account_category,  class_name: "AccountingModule::AccountCategory"
  end
end
