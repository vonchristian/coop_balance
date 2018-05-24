module AccountingModule
  module Accounts
    class ActivationsController < ApplicationController
      def create
        @account = AccountingModule::Account.find(params[:account_id])
        @account.active = true
        @account.save
        redirect_to accounting_module_accounts_url, notice: "Activated successfully."
      end
    end
  end
end
