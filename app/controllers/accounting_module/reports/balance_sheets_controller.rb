module AccountingModule
  module Reports
    class BalanceSheetsController < ApplicationController
      def index
        first_entry = AccountingModule::Entry.order('entry_date ASC').first
        @from_date = first_entry ? DateTime.parse(first_entry.entry_date.strftime("%B %e, %Y")) : Time.zone.now
        @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Time.zone.now
        @assets = AccountingModule::Asset.active.order(:code).all
        @liabilities = AccountingModule::Liability.active.order(:code).all
        @equity = AccountingModule::Equity.active.order(:code).all
        @cooperative = current_cooperative
        respond_to do |format|
          format.html # index.html.erb
          format.pdf do
            pdf = AccountingModule::Reports::BalanceSheetPdf.new(
              from_date:    @from_date,
              to_date:      @to_date,
              assets:       @assets,
              liabilities:  @liabilities,
              equity:       @equity,
              view_context: view_context,
              cooperative:  @cooperative)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Balance Sheet.pdf"
          end
        end
      end
    end
  end
end
