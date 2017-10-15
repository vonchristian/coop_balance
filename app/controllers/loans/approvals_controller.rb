module Loans
  class ApprovalsController < ApplicationController
    def new 
      @loan = LoansModule::Loan.find(params[:loan_id])
      @approval = @loan.loan_approvals.build
    end
    def create
      @loan = LoansModule::Loan.find(params[:loan_id])
      @approval = @loan.loan_approvals.create(approval_params)
      if @approval.save 
        redirect_to loan_path(@loan), notice: "Approved successfully."
      else
        render :new 
      end
    end

    private 
    def approval_params
      params.require(:loans_module_loan_approval).permit(:date_approved, :approver_id, :description)
    end
  end
end
