module AccountingModule
  module Reports
    class FinancialConditionsController < ApplicationController
      def index
        @comparison = AccountingModule::FinancialConditionComparison.new
        first_entry = AccountingModule::Entry.order('entry_date ASC').first
        @from_date = first_entry ? DateTime.parse(first_entry.entry_date.strftime("%B %e, %Y")) : Time.zone.now
        @to_date = params[:entry_date] ? DateTime.parse(params[:entry_date]) : Time.zone.now
        @assets = AccountingModule::Asset.active.order(:code).all
        @liabilities = AccountingModule::Liability.active.order(:code).all
        @equity = AccountingModule::Equity.active.order(:code).all
        @employee = current_user
        respond_to do |format|
          format.html # index.html.erb
          format.pdf do
            pdf = AccountingModule::Reports::FinancialConditionPdf.new(@from_date, @to_date, @assets, @liabilities, @equity, @employee, view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Disbursement.pdf"
          end
        end
      end
    end
  end
end
