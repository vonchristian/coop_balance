module SavingsAccounts
  class AccountingController < ApplicationController
    def index
      @savings_account = current_office.savings.find(params[:savings_account_id])
    end
  end
end
