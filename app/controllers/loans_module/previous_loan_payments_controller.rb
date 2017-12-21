module LoansModule
  class PreviousLoanPaymentsController < ApplicationController
    def new
      @previous_loan = LoansModule::Loan.find(params[:previous_loan_id])
      @loan = LoansModule::Loan.find(params[:loan_id])
      @payment = LoansModule::PreviousLoanPaymentForm.new
    end
    def create
      @loan = LoansModule::Loan.find(params[:loan_id])
      @payment = LoansModule::PreviousLoanPaymentForm.new(previous_loan_payment_params)
      if @payment.valid?
        @payment.save
        redirect_to loans_module_loan_application_url(@loan), notice: "Previous loan payment saved successfully"
      else
        render :new
      end
    end

    private
    def previous_loan_payment_params
      params.require(:loans_module_previous_loan_payment_form).permit(:principal_amount,
                  :interest_amount,
                  :penalty_amount,
                  :discount_amount,
                  :loan_id,
                  :previous_loan_id,
                  :description,
                  :reference_number,
                  :date)
    end
  end
end
