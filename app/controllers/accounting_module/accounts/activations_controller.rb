module AccountingModule
  module Accounts
    class ActivationsController < ApplicationController
      def create
        @account = current_cooperative.accounts.find(params[:account_id])
        @account.active = true
        @account.save
        redirect_to accounting_module_account_settings_url(@account), notice: "Activated successfully."
      end
    end
  end
end
