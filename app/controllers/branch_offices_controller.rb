class BranchOfficesController < ApplicationController
  def index
    @branch_offices = CoopConfigurationsModule::BranchOffice.all
  end
  def show
    @branch_office = CoopConfigurationsModule::BranchOffice.find(params[:id])
  end
end
