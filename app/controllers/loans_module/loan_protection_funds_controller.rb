module LoansModule
  class LoanProtectionFundsController < ApplicationController
    def new
      @loan = current_cooperative.loans.find(params[:loan_id])
      @loan_protection_fund = @loan.loan_protection_funds.build
    end
    def create
      @loan = current_cooperative.loans.find(params[:loan_id])
      @loan_protection_fund = @loan.loan_protection_funds.create(loan_protection_fund_params)
      if @loan_protection_fund.save
        redirect_to loan_url(@loan), notice: "Loan Protection Fund saved successfully"
      else
        render :new
      end
    end

    private
    def loan_protection_fund_params
      params.require(:loans_module_loan_protection_fund).permit(:amount)
    end
  end
end
