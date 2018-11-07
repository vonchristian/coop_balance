module SavingsAccounts
  class SettingsController < ApplicationController
    def index
      @savings_account = current_cooperative.savings.find(params[:savings_account_id])
    end
  end
end
