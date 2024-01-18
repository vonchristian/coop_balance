module TreasuryModule
  class CashAccountsController < ApplicationController
    def index
      @cash_accounts = if current_user.general_manager?
                         current_office.cash_accounts
                       else
                         current_user.cash_accounts
                       end
    end

    def show
      @from_date = params[:from_date] ? Date.parse(params[:from_date]) : Time.zone.today
      @to_date = params[:to_date] ? Date.parse(params[:to_date]) : Time.zone.today
      @cash_account = current_office.cash_accounts.find(params[:id])
      if params[:search].present?
        @pagy, @entries      = pagy(@cash_account.entries.text_search(params[:search]))
      else
        @pagy, @entries      = pagy(@cash_account.entries.includes(:commercial_document).order(entry_date: :desc).order(created_at: :desc))
      end
    end
  end
end
