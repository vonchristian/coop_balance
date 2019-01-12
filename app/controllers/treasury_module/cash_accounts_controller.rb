module TreasuryModule
  class CashAccountsController < ApplicationController
    def index
      if current_user.general_manager?
        @cash_accounts = current_cooperative.cash_accounts
      else
        @cash_accounts = current_user.cash_accounts
      end
    end
    def show
      @from_date = params[:from_date] ? Date.parse(params[:from_date]) : Date.today
      @to_date = params[:to_date] ? Date.parse(params[:to_date]) : Date.today
      @cash_account = current_cooperative.cash_accounts.find(params[:id])
      if params[:from_date] && params[:to_date]
        @entries      = @cash_account.entries.entered_on(from_date: @from_date, to_date: @to_date).
        order(entry_date: :asc).
        paginate(page: params[:page], per_page: 25)
      else
        @entries      = @cash_account.entries.
        order(entry_date: :asc).
        paginate(page: params[:page], per_page: 25)
      end
    end
  end
end
