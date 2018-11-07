module TreasuryModule
  class CashReceiptsController < ApplicationController
    def index
      if params[:search].present?
        @cash_receipts = current_cooperative.employee_cash_accounts.
        cash_accounts.
        debit_entries.
        text_search(params[:search]).
        order(entry_date: :desc).
        paginate(page: params[:page], per_page: 25)
      else
        @cash_receipts = current_cooperative.employee_cash_accounts.
        cash_accounts.
        debit_entries.
        order(entry_date: :desc).
        paginate(page: params[:page], per_page: 25)
      end
    end
  end
end
