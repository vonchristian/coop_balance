module AccountingModule
  module Reports
    class BalanceSheetsController < ApplicationController
      def index
        first_entry = current_cooperative.entries.order('entry_date ASC').first
        @from_date = first_entry ? DateTime.parse(first_entry.entry_date.strftime("%B %e, %Y")) : Time.zone.now
        @to_date = params[:to_date] ? DateTime.parse(params[:to_date]).end_of_day : Date.current
        @assets = current_office.accounts.assets.active.order(:code).all
        @liabilities = current_cooperative.accounts.liabilities.active.order(:code).all
        @equity = current_cooperative.accounts.equities.active.order(:code).all
        @cooperative = current_cooperative
        @office = current_user.office
        respond_to do |format|
          format.html # index.html.erb
          format.xlsx
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
