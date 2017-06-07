module LoansDepartment
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
        redirect_to loans_department_member_url(@member), notice: "Loan application saved successfully."
      else
        render :new
      end
    end

    private
    def loan_params
      params.require(:loans_department_loan).permit(:loan_product_id, :loan_amount, :application_date)
    end
  end
end
