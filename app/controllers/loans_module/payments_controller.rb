module LoansModule
  class PaymentsController < ApplicationController
    def new
      @loan = current_cooperative.loans.find(params[:loan_id])
      @payment = LoanPaymentForm.new
    end
    def create
      @loan = current_cooperative.loans.find(params[:loan_id])
      @payment = LoanPaymentForm.new(payment_params)
      if @payment.valid?
        @payment.save
        redirect_to loans_module_loan_path(@loan), notice: "Loan payment saved successfully."
      else
        render :new
      end
    end

    private
    def payment_params
      params.require(:loan_payment_form).permit(:amount, :loan_id, :reference_number, :date)
    end
  end
end
