module LoansModule
  class LoanApplicationsController < ApplicationController
    def new
      @member = Member.find(params[:member_id])
      @loan = @member.loans.build
    end
    def create
      @member = Member.find(params[:member_id])
      @loan = @member.loans.create(loan_params)
      if @loan.valid?
        @loan.save
        redirect_to loans_module_member_url(@member), notice: "Loan application saved successfully."
      else
        render :new
      end
    end

    private
    def loan_params
      params.require(:loans_module_loan).permit(:loan_product_id, :loan_amount, :application_date, :duration, :loan_term_duration)
    end
  end
end
