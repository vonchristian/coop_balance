module AccountingModule
  class AccountingReportAccountCategorization < ApplicationRecord
    belongs_to :accounting_report, class_name: 'AccountingModule::AccountingReport'
    belongs_to :account_category, polymorphic: true
  end
end 
