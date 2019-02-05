module TreasuryModule
  module CashAccounts
    class ReceiptsController < ApplicationController
      def index
        @from_date          = params[:from_date] ? Date.parse(params[:from_date]) : Date.current
        @to_date            = params[:from_date] ? Date.parse(params[:to_date]) : Date.current
        @cash_account       = current_user.cash_accounts.find(params[:cash_account_id])
        @entries            = @cash_account.debit_entries
        @entries_for_report = @cash_account.debit_entries.entered_on(from_date: @from_date, to_date: @to_date)
        respond_to do |format|
          format.html
          format.xlsx
        end
      end
    end
  end
end
