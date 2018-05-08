module SavingsAccounts
  class SettingsController < ApplicationController
    def index
      @savings_account = MembershipsModule::Saving.find(params[:savings_account_id])
    end
  end
end
