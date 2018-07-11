module CooperativeServices
  module Accounts
    class ActivationsController < ApplicationController
      def create
        @cooperative_service = current_cooperative.cooperative_services.find(params[:cooperative_service_id])
        @account = AccountingModule::Account.find(params[:account_id])
        @cooperative_service.accounts << @account
        redirect_to new_cooperative_service_account_url, notice: "Account added successfully."
      end
    end
  end
end

