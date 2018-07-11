module LoansModule
  class LoansController < ApplicationController
    def index
      @loans = LoansModule::Loan.all
    end
    def show
      @loan = LoansModule::Loan.find(params[:id])
    end
    def destroy
      @loan = LoansModule::Loan.find(params[:id])
      @loan.destroy
      redirect_to loans_url, alert: "Loan deleted successfully."
    end
  end
end
