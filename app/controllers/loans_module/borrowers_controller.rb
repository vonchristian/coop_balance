module LoansModule
  class BorrowersController < ApplicationController
    def index
      @borrowers = Loan.borrowers
    end
  end
end
