module SavingsAccounts
  class BalanceTransfersController < ApplicationController
    def new
      @origin_saving      = current_cooperative.savings.find(params[:savings_account_id])
      @savings_accounts   = current_office.savings
    end
  end
end
