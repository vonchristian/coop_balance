module LoansModule
  class PreviousLoanPaymentsController < ApplicationController
    def new
      @loan = LoansModule::Loan.find(params[:loan_id])
    end
  end
end
