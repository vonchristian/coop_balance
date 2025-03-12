module AccountingModule
  module Entries
    class CashReceiptsController < ApplicationController
      def index
        @cash_account = params[:cash_account_id] ? current_office.cash_accounts.find(params[:cash_account_id]) : current_office.cash_accounts.last
        @from_date    = params[:from_date] ? DateTime.parse(params[:from_date]) : Date.current.beginning_of_year
        @to_date      = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.current.end_of_year
        if params[:search].present?
          @entries_for_pdf = @cash_account.debit_entries.text_search(params[:search])
          @pagy, @entries  = pagy(@cash_account.debit_entries.includes(:commercial_document, :debit_amounts).order(ref_number_integer: :asc).text_search(params[:search]))
        else
          @entries_for_pdf = @cash_account.debit_entries.not_cancelled.entered_on(from_date: @from_date, to_date: @to_date)
          @pagy, @entries  = pagy(@cash_account.debit_entries.includes(:commercial_document, :debit_amounts).order(ref_number_integer: :asc).entered_on(from_date: @from_date, to_date: @to_date))
        end
        respond_to do |format|
          format.html
          format.csv { render_csv }
          format.pdf do
            pdf = AccountingModule::EntriesPdf.new(
              from_date: @from_date,
              to_date: @to_date,
              entries: @entries_for_pdf,
              title: "Cash Receipts Journal",
              employee: current_user,
              cooperative: current_cooperative,
              view_context: view_context
            )
            send_data pdf.render, type: "application/pdf", disposition: "inline", file_name: "Entries report.pdf"
            nil
          end
        end
      end

      private

      def render_csv
        # Tell Rack to stream the content
        headers.delete("Content-Length")

        # Don't cache anything from this generated endpoint
        headers["Cache-Control"] = "no-cache"

        # Tell the browser this is a CSV file
        headers["Content-Type"] = "text/csv"

        # Make the file download with a specific filename
        headers["Content-Disposition"] = 'attachment; filename="Cash Receipts Journal.csv"'

        # Don't buffer when going through proxy servers
        headers["X-Accel-Buffering"] = "no"

        # Set an Enumerator as the body
        self.response_body = csv_body

        response.status = 200
      end

      def csv_body
        Enumerator.new do |yielder|
          yielder << CSV.generate_line([ "#{@cash_account.name} - Cash Receipts Journal" ])
          yielder << CSV.generate_line([ "DATE", "MEMBER/PAYEE", "PARTICULARS", "REF NO.", "ACCOUNT", "DEBIT", "CREDIT" ])
          @entries_for_pdf.order(reference_number: :asc).each do |entry|
            yielder << CSV.generate_line([
                                           entry.entry_date.strftime("%B %e, %Y"),
                                           entry.display_commercial_document,
                                           entry.description,
                                           entry.reference_number
                                         ])
            entry.debit_amounts.each do |debit_amount|
              yielder << CSV.generate_line([ "", "", "", "", debit_amount.account_display_name,
                                            debit_amount.amount ])
            end
            entry.credit_amounts.each do |credit_amount|
              yielder << CSV.generate_line([ "", "", "", "", "    #{credit_amount.account_display_name}", "", credit_amount.amount ])
            end
          end
          yielder << CSV.generate_line([ "" ])
          yielder << CSV.generate_line([ "Accounts Summary" ])
          yielder << CSV.generate_line(%w[DEBIT ACCOUNT CREDIT])
          ids = @entries_for_pdf.accounts.pluck(:ledger_id)
          current_office.ledgers.where(id: ids.uniq.compact.flatten).updated_at(from_date: @from_date, to_date: @to_date).uniq.each do |ledger|
            yielder << CSV.generate_line([
                                           ledger.debit_amounts.not_cancelled.where(entry_id: @entries_for_pdf.ids).uniq.sum(&:amount),
                                           ledger.title,
                                           ledger.credit_amounts.not_cancelled.where(entry_id: @entries_for_pdf.ids).uniq.sum(&:amount)
                                         ])
          end
        end
      end
    end
  end
end
