module AccountingModule
  module Entries
    class CashReceiptsController < ApplicationController
      def index
          @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : Date.current.beginning_of_year
          @to_date   = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.current.end_of_year
          if params[:search].present?
            @entries_for_pdf = current_office.cash_accounts.debit_entries.order(reference_number: :desc).text_search(params[:search])
            @pagy, @entries  = pagy(current_office.cash_accounts.debit_entries.order(reference_number: :desc).text_search(params[:search]))
          else 
            @entries_for_pdf = current_office.cash_accounts.debit_entries.order(reference_number: :desc).entered_on(from_date: @from_date, to_date: @to_date)
            @pagy, @entries  = pagy(current_office.cash_accounts.debit_entries.order(reference_number: :desc).entered_on(from_date: @from_date, to_date: @to_date))
          end
        respond_to do |format|
          format.html
          format.xlsx
          format.pdf do
            pdf = AccountingModule::EntriesPdf.new(
              from_date:    @from_date,
              to_date:      @to_date,
              entries:      @entries_for_pdf,
              title:        "Cash Receipts Journal",
              employee:     current_user,
              cooperative:  current_cooperative,
              view_context: view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Entries report.pdf"
            pdf=nil

          end
        end
      end
      
    end
  end
end
