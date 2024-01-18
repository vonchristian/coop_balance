module TreasuryModule
  module CashAccounts
    class DisbursementsController < ApplicationController
      def index
        @from_date          = params[:from_date] ? Date.parse(params[:from_date]) : Date.current
        @to_date            = params[:from_date] ? Date.parse(params[:to_date]) : Date.current
        @cash_account       = current_user.cash_accounts.find(params[:cash_account_id])
        @entries            = @cash_account.credit_entries
        @entries_for_report = @cash_account.credit_entries.entered_on(from_date: @from_date, to_date: @to_date)
        respond_to do |format|
          format.html
          format.xlsx
          format.pdf do
            pdf = AccountingModule::CashBooks::CashDisbursementsPdf.new(
              from_date: @from_date,
              to_date: @to_date,
              entries: @entries_for_report,
              organization: @organization,
              employee: current_user,
              cooperative: current_cooperative,
              title: 'Cash Receipts',
              view_context: view_context
            )
            send_data pdf.render, type: 'application/pdf', disposition: 'inline', file_name: 'Entries report.pdf'
            nil
          end
        end
      end
    end
  end
end
