module AccountingModule
  class SettingsController < ApplicationController
    def index
      @account = current_cooperative.accounts.find(params[:account_id])
    end
  end
end
