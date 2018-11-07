module LoansModule
  class LoansController < ApplicationController
    def index
      @loans = current_cooperative.loans.paginate(page: params[:page], per_page: 25)
    end
    def show
      @loan = current_cooperative.loans.find(params[:id])
    end
    def destroy
      @loan = current_cooperative.loans.find(params[:id])
      @loan.destroy
      redirect_to loans_url, alert: "Loan deleted successfully."
    end
  end
end
