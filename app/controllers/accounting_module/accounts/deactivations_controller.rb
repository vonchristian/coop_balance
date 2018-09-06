module AccountingModule
  module Accounts
    class DeactivationsController < ApplicationController
      def create
        @account = AccountingModule::Account.find(params[:account_id])
        @account.active = false
        @account.save
        redirect_to accounting_module_account_settings_url(@account), alert: "Deactivated successfully."
      end
    end
  end
end
