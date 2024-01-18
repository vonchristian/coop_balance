module TreasuryModule
  module CashAccounts
    class DailyTransactionsController < ApplicationController
      def index
        @from_date = Date.current.beginning_of_day
        @to_date      = Date.current.end_of_day
        @cash_account = current_office.cash_accounts.find(params[:cash_account_id])
        respond_to do |format|
          format.html
          format.pdf do
            pdf = CashBooks::DailyTransactionPdf.new(
              from_date: @from_date,
              to_date: @to_date,
              cash_account: @cash_account,
              view_context: view_context,
              employee: current_user
            )
            send_data pdf.render, type: 'application/pdf', disposition: 'inline', file_name: 'Daily Transaction.pdf'
            nil
          end
        end
      end
    end
  end
end