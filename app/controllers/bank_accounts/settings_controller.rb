module BankAccounts
  class SettingsController < ApplicationController
    def index
      @bank_account = current_cooperative.bank_accounts.find(params[:bank_account_id])
    end
  end
end
