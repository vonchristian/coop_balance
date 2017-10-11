class LoanCoMakersController < ApplicationController
  def destroy 
    @co_maker = LoansModule::LoanCoMaker.find(params[:id])
    @co_maker.destroy 
    redirect_to loan_url(@co_maker.loan), notice: "Co Maker removed successfully."
  end
end 