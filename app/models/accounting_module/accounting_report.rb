module AccountingModule
  class AccountingReport < ApplicationRecord
    enum report_type: [:balance_sheet, :income_statement, :statement_of_operation]
    belongs_to :office, class_name: 'Cooperatives::Office'
    has_many :accounting_report_account_categorizations, class_name: 'AccountingModule::AccountingReportAccountCategorization'
    has_many :account_categories, through: :accounting_report_account_categorizations, source: :account_category
    
    has_many :level_one_asset_account_categories,     through: :accounting_report_account_categorizations, source: :account_category, source_type: 'AccountingModule::AccountCategories::LevelOneAccountCategories::Asset'
    has_many :level_one_liability_account_categories, through: :accounting_report_account_categorizations, source: :account_category, source_type: 'AccountingModule::AccountCategories::LevelOneAccountCategories::Liability'
    has_many :level_one_equity_account_categories,    through: :accounting_report_account_categorizations, source: :account_category, source_type: 'AccountingModule::AccountCategories::LevelOneAccountCategories::Equity'
    has_many :level_one_revenue_account_categories,   through: :accounting_report_account_categorizations, source: :account_category, source_type: 'AccountingModule::AccountCategories::LevelOneAccountCategories::Revenue'
    has_many :level_one_expense_account_categories,   through: :accounting_report_account_categorizations, source: :account_category, source_type: 'AccountingModule::AccountCategories::LevelOneAccountCategories::Expense'

    has_many :level_two_asset_account_categories,     through: :accounting_report_account_categorizations, source: :account_category, source_type: 'AccountingModule::AccountCategories::LevelTwoAccountCategories::Asset'
    has_many :level_two_liability_account_categories, through: :accounting_report_account_categorizations, source: :account_category, source_type: 'AccountingModule::AccountCategories::LevelTwoAccountCategories::Liability'
    has_many :level_two_equity_account_categories,    through: :accounting_report_account_categorizations, source: :account_category, source_type: 'AccountingModule::AccountCategories::LevelTwoAccountCategories::Equity'
    has_many :level_two_revenue_account_categories,   through: :accounting_report_account_categorizations, source: :account_category, source_type: 'AccountingModule::AccountCategories::LevelTwoAccountCategories::Revenue'
    has_many :level_two_expense_account_categories,   through: :accounting_report_account_categorizations, source: :account_category, source_type: 'AccountingModule::AccountCategories::LevelTwoAccountCategories::Expense'

    has_many :level_three_asset_account_categories,     through: :accounting_report_account_categorizations, source: :account_category, source_type: 'AccountingModule::AccountCategories::LevelThreeAccountCategories::Asset'
    has_many :level_three_liability_account_categories, through: :accounting_report_account_categorizations, source: :account_category, source_type: 'AccountingModule::AccountCategories::LevelThreeAccountCategories::Liability'
    has_many :level_three_equity_account_categories,    through: :accounting_report_account_categorizations, source: :account_category, source_type: 'AccountingModule::AccountCategories::LevelThreeAccountCategories::Equity'
    has_many :level_three_revenue_account_categories,   through: :accounting_report_account_categorizations, source: :account_category, source_type: 'AccountingModule::AccountCategories::LevelThreeAccountCategories::Revenue'
    has_many :level_three_expense_account_categories,   through: :accounting_report_account_categorizations, source: :account_category, source_type: 'AccountingModule::AccountCategories::LevelThreeAccountCategories::Expense'
    
    has_many :level_four_asset_account_categories,     through: :accounting_report_account_categorizations, source: :account_category, source_type: 'AccountingModule::AccountCategories::LevelFourAccountCategories::Asset'
    has_many :level_four_liability_account_categories, through: :accounting_report_account_categorizations, source: :account_category, source_type: 'AccountingModule::AccountCategories::LevelFourAccountCategories::Liability'
    has_many :level_four_equity_account_categories,    through: :accounting_report_account_categorizations, source: :account_category, source_type: 'AccountingModule::AccountCategories::LevelFourAccountCategories::Equity'
    has_many :level_four_revenue_account_categories,   through: :accounting_report_account_categorizations, source: :account_category, source_type: 'AccountingModule::AccountCategories::LevelFourAccountCategories::Revenue'
    has_many :level_four_expense_account_categories,   through: :accounting_report_account_categorizations, source: :account_category, source_type: 'AccountingModule::AccountCategories::LevelFourAccountCategories::Expense'
    
    def pdf_renderer
      ("AccountingModule::Reports::" + report_type.titleize.gsub(" ", "") +  "Pdf").constantize
    end 
  end
end
