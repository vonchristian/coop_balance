module LoansModule
  class ApprovalsController < ApplicationController
    def create
      @loan = LoansModule::Loan.find(params[:loan_id])
      @loan.loan_approvals.create(approver: current_user, date_approved: Time.zone.now)
      redirect_to loans_module_loan_path(@loan), notice: "Approved"
    end
  end
end
