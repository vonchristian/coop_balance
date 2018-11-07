class BranchOfficesController < ApplicationController
  def index
    @branch_offices = current_cooperative.branch_offices
  end
  def show
    @branch_office = current_cooperative.branch_offices.find(params[:id])
  end
end
