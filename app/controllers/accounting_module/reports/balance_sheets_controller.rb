module AccountingModule
  module Reports
    class BalanceSheetsController < ApplicationController
      def index
        first_entry = AccountingModule::Entry.order('entry_date ASC').first
        @from_date = first_entry ? DateTime.parse(first_entry.entry_date.strftime("%B %e, %Y")) : Time.zone.now
        @to_date = params[:entry_date] ? DateTime.parse(params[:entry_date]) : Time.zone.now
        @assets = AccountingModule::Asset.all
        @liabilities = AccountingModule::Liability.all
        @equity = AccountingModule::Equity.all

        respond_to do |format|
          format.html # index.html.erb
          format.pdf do
            pdf = AccountingModule::Reports::BalanceSheetPdf.new(@from_date, @to_date, @assets, @liabilities, @equity, view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Disbursement.pdf"
          end
        end
      end
    end
  end
end
