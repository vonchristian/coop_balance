module AccountingModule
  class SettingsController < ApplicationController
    def index
      @account = AccountingModule::Account.find(params[:account_id])
    end
  end
end
