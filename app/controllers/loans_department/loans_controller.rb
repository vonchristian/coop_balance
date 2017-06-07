module LoansDepartment
  class LoansController < ApplicationController
    def index
      @loans = Loan.all
    end
    def show
      @loan = Loan.find(params[:id])
    end
  end
end
