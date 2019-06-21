module AccountingModule
  module AccountingReports
    class AccountCategoriesController < ApplicationController
      def new
        @accounting_report = current_office.accounting_reports.find(params[:accounting_report_id])
        @category          = @accounting_report.accounting_report_account_categories.build
      end
      def create
        @accounting_report = current_office.accounting_reports.find(params[:accounting_report_id])
        @category          = @accounting_report.accounting_report_account_categories.create(category_params)
        if @category.valid?
          @category.save!
          redirect_to accounting_module_accounting_report_url(@accounting_report), notice: 'created successfully'
        else
          render :new
        end
      end

      private
      def category_params
        params.require(:accounting_module_accounting_report_account_category).
        permit(:account_category_id)
      end 
    end
  end
end
