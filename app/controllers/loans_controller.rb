class LoansController < ApplicationController
  def index 
    @loans = LoansModule::Loan.all.paginate(page: params[:page], per_page: 30)
  end 
  def show 
    @loan = LoansModule::Loan.find(params[:id])
  end 
end 