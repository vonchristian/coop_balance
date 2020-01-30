module TreasuryModule
  class CashAccountsController < ApplicationController
    def index
      if current_user.general_manager?
        @cash_accounts = current_office.cash_accounts
      else
        @cash_accounts = current_user.cash_accounts
      end
    end
    def show
      @from_date = params[:from_date] ? Date.parse(params[:from_date]) : Date.today
      @to_date = params[:to_date] ? Date.parse(params[:to_date]) : Date.today
      @cash_account = current_office.cash_accounts.find(params[:id])
      if params[:from_date] && params[:to_date]
        @pagy, @entries      = pagy(@cash_account.entries.entered_on(from_date: @from_date, to_date: @to_date).order(entry_date: :desc).order(created_at: :desc))
      else
        @pagy, @entries      = pagy(@cash_account.entries.order(entry_date: :desc).order(created_at: :desc))
      end
    end
  end
end
