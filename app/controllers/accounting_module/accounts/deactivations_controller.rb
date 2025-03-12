module AccountingModule
  module Accounts
    class DeactivationsController < ApplicationController
      def create
        @account = current_cooperative.accounts.find(params[:account_id])
        if @account.balance(to_date: Time.zone.today).zero?
          @account.active = false
          @account.save
          redirect_to accounting_module_account_settings_url(@account), alert: "Deactivated successfully."
        else
          redirect_to accounting_module_account_settings_url(@account), alert: "Deactivation failed! Create adjusting entries for this account to make the balance zero."
        end
      end
    end
  end
end
