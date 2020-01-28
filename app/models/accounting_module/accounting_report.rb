module AccountingModule
  class AccountingReport < ApplicationRecord
    enum report_type: [:balance_sheet, :income_statement, :statement_of_operation]
    belongs_to :office
    has_many :accounting_report_account_categories, class_name: 'AccountingModule::AccountingReportAccountCategory'
    has_many :account_categories, through: :accounting_report_account_categories, source: :account_category
    validates :title, presence: true, uniqueness: { scope: :office_id }
    
    def pdf_renderer
      ("AccountingModule::Reports::" + report_type.titleize.gsub(" ", "") + "Pdf").constantize
    end 
  end
end
