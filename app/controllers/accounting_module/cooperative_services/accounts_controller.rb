module AccountingModule
  module CooperativeServices
    class AccountsController < ApplicationController
      def index
        @cooperative_service = current_cooperative.cooperative_services.find(params[:cooperative_service_id])
        @pagy, @accounts     = pagy(@cooperative_service.accounts)
      end
      def new
        @cooperative_service = current_cooperative.cooperative_services.find(params[:cooperative_service_id])
        @account             = @cooperative_service.accountable_accounts.build
        if params[:search].present?
          @pagy, @accounts     = pagy(current_cooperative.accounts.text_search(params[:search]))
        else
          @pagy, @accounts     = pagy(current_cooperative.accounts)
        end
      end
      def create
        @cooperative_service = current_cooperative.cooperative_services.find(params[:cooperative_service_id])
        @account             = @cooperative_service.accountable_accounts.create(account_params)
        if params[:search].present?
          @pagy, @accounts     = pagy(current_cooperative.accounts.text_search(params[:search]))
        else
          @pagy, @accounts     = pagy(current_cooperative.accounts)
        end
        if @account.valid?
          @account.save!
          redirect_to new_accounting_module_cooperative_service_account_url(@cooperative_service), notice: 'added successfully'
        else
          render :new
        end
      end

      private
      def account_params
        params.require(:accounting_module_accountable_account).
        permit(:account_id)
      end
    end
  end
end
