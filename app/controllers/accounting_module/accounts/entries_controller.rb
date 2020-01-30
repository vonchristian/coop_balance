module AccountingModule
  module Accounts
    class EntriesController < ApplicationController
      def index
        @account   = current_office.accounts.find(params[:account_id])
        @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : Date.today
        @to_date   = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.today

        if params[:from_date] && params[:to_date]
          @pagy, @entries = pagy(@account.entries.includes(:recorder).entered_on(from_date: @from_date, to_date: @to_date).order(entry_date: :desc))
        else
          @pagy, @entries = pagy(@account.entries.includes(:recorder).order(entry_date: :desc))
        end

        respond_to do |format|
          format.html
          format.csv { render_csv }
          format.pdf do
            pdf = AccountingModule::Accounts::EntriesReportPdf.new(
              entries:      @account.entries.entered_on(from_date: @from_date, to_date: @to_date),
              account:      @account,
              employee:     current_user,
              from_date:    @from_date,
              to_date:      @to_date,
              view_context: view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Entries Report.pdf"
          end
        end
      end

      def render_csv
        # Tell Rack to stream the content
        headers.delete("Content-Length")
  
        # Don't cache anything from this generated endpoint
        headers["Cache-Control"] = "no-cache"
  
        # Tell the browser this is a CSV file
        headers["Content-Type"] = "text/csv"
  
        # Make the file download with a specific filename
        headers["Content-Disposition"] = "attachment; filename=\"Entries.csv\""
  
        # Don't buffer when going through proxy servers
        headers["X-Accel-Buffering"] = "no"
  
        # Set an Enumerator as the body
        self.response_body = csv_body
  
        response.status = 200
      end
  
      private
  
      def csv_body
        Enumerator.new do |yielder|
          yielder << CSV.generate_line(["#{current_office.name} - #{@account.name} Entries Report"])
          yielder << CSV.generate_line(["Date", "Description", "Member", "REF #", 'Debit', 'Credit',  "Balance"])
          @account.entries.entered_on(from_date: @from_date, to_date: @to_date).order(entry_date: :desc).order(created_at: :desc).each do |entry|
            yielder << CSV.generate_line([
              entry.entry_date.strftime('%B, %e, %Y'),
              entry.description,
              entry.commercial_document.try(:name),
              entry.reference_number,
              entry.debit_amounts.where(account: @account).total,
              entry.credit_amounts.where(account: @account).total,
              @account.balance(to_date: entry.entry_date, to_time: entry.created_at)
              ])
          end
        end 
      end 
    end
  end
end
