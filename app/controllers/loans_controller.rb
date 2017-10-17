class LoansController < ApplicationController
  def index 
    if params[:loan_product_id].present?
      @loans = LoansModule::LoanProduct.find(params[:loan_product_id]).loans
    else
      @loans = LoansModule::Loan.all.paginate(page: params[:page], per_page: 30)
    end
  end 
  def show 
    @loan = LoansModule::Loan.find(params[:id])
  end 
end 