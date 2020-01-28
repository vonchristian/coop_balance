require 'rails_helper'

module AccountingModule
  describe AccountingReport do 
    describe 'associations' do 
      it { is_expected.to belong_to :office }
      it { is_expected.to have_many :accounting_report_account_categorizations }
      
      it { is_expected.to have_many :level_one_asset_account_categories }
      it { is_expected.to have_many :level_one_liability_account_categories }
      it { is_expected.to have_many :level_one_equity_account_categories }
      it { is_expected.to have_many :level_one_revenue_account_categories }
      it { is_expected.to have_many :level_one_expense_account_categories }

      it { is_expected.to have_many :level_two_asset_account_categories }
      it { is_expected.to have_many :level_two_liability_account_categories }
      it { is_expected.to have_many :level_two_equity_account_categories }
      it { is_expected.to have_many :level_two_revenue_account_categories }
      it { is_expected.to have_many :level_two_expense_account_categories }

      it { is_expected.to have_many :level_three_asset_account_categories }
      it { is_expected.to have_many :level_three_liability_account_categories }
      it { is_expected.to have_many :level_three_equity_account_categories }
      it { is_expected.to have_many :level_three_revenue_account_categories }
      it { is_expected.to have_many :level_three_expense_account_categories }
    end 

    it '#pdf_renderer' do 
      income_statement       = create(:accounting_report, report_type: 'income_statement', title: 'Catering and Restaurant')
      balance_sheet          = create(:accounting_report, report_type: 'balance_sheet', title: 'Catering and Restaurant')
      statement_of_operation = create(:accounting_report, report_type: 'statement_of_operation', title: 'Catering and Restaurant')
   
      expect(income_statement.pdf_renderer).to eql AccountingModule::Reports::IncomeStatementPdf
      expect(balance_sheet.pdf_renderer).to eql AccountingModule::Reports::BalanceSheetPdf
      expect(statement_of_operation.pdf_renderer).to eql AccountingModule::Reports::StatementOfOperationPdf
    end 
  end 
end 