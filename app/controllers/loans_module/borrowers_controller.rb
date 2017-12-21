module LoansModule
  class BorrowersController < ApplicationController
    def index
      @borrowers = Loan.borrowers
    end
    def show
      @borrower = Member.find(params[:id])
    end
  end
end
