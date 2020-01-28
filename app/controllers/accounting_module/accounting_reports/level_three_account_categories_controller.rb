module AccountingModule
  module AccountingReports 
    class LevelThreeAccountCategoriesController < ApplicationController
      def new 
        @accounting_report   = current_office.accounting_reports.find(params[:accounting_report_id])
        @l3_account_category = @accounting_report.accounting_report_account_categorizations.build 
        @pagy, @level_three_account_categories = pagy(current_office.level_three_account_categories)
      end 

      def create 
        @accounting_report   = current_office.accounting_reports.find(params[:accounting_report_id])
        @l3_account_category = @accounting_report.accounting_report_account_categorizations.create(account_category_params)
        @l3_account_category.save!
        redirect_to new_accounting_module_accounting_report_level_three_account_category_url(@accounting_report), notice: 'added successfully'
      end 

      private 

      def account_category_params
        params.require(:accounting_module_accounting_report_account_categorization).
        permit(:account_category_id, :account_category_type)
      end 
    end 
  end 
end 