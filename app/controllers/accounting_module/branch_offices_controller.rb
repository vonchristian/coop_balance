module AccountingModule
  class BranchOfficesController < ApplicationController
    def index
      @branch_offices = CoopConfigurationsModule::BranchOffice.all
    end
    def show
      @branch_office = CoopConfigurationsModule::BranchOffice.find(params[:id])
      @accounts = AccountingModule::Account.all.paginate(page: params[:page], per_page: 500)
    end
  end
end
