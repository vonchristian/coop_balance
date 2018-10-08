module BankAccounts
  class SettingsController < ApplicationController
    def index
      @bank_account = BankAccount.find(params[:bank_account_id])
    end
  end
end