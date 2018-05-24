module AccountingModule
  module Accounts
    class DeactivationsController < ApplicationController
      def create
        @account = AccountingModule::Account.find(params[:account_id])
        @account.active = false
        @account.save
        redirect_to accounting_module_accounts_url, alert: "Deactivated successfully."
      end
    end
  end
end
