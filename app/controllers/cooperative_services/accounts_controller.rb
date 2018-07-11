module CooperativeServices
  class AccountsController < ApplicationController
    def new
      @cooperative_service = current_cooperative.cooperative_services.find(params[:cooperative_service_id])
      if params[:search].present?
        @accounts = AccountingModule::Account.text_search(params[:search]).paginate(page: params[:page], per_page: 50)
      else
        @accounts = AccountingModule::Account.all.order(:code).paginate(page: params[:page], per_page: 50)
      end
    end
  end
end
