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
      @cash_account = current_cooperative.cash_accounts.find(params[:id])
    end
  end
end
