module LoansModule
  class BorrowersController < ApplicationController
    def index
      @borrowers = Loan.borrowers
    end
    def show
      if @borrower.class == "Member"
        @borrower = Member.find(params[:id])
      elsif @borrower.class == "User"
        @borrower = User.find(params[:id])
      end
    end
  end
end
