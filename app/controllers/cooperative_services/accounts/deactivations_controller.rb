module CooperativeServices
  module Accounts
    class DeactivationsController < ApplicationController
      def create
        @cooperative_service = current_cooperative.cooperative_services.find(params[:cooperative_service_id])
        @account = AccountingModule::Account.find(params[:account_id])
        @coop_service_account = @cooperative_service.accountable_accounts.find_by(account_id: @account.id)
        @coop_service_account.destroy
        redirect_to new_cooperative_service_account_url(@cooperative_service), notice: "Account removed successfully."
      end
    end
  end
end

