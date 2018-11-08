module TreasuryModule
  class CashAccountsController < ApplicationController
    def index
      @cash_accounts = current_user.cash_accounts
    end
    def show
      @cash_account = current_user.cash_accounts.find(params[:id])
    end
  end
end
