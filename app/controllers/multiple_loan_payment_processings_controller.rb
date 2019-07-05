class MultipleLoanPaymentProcessingsController < ApplicationController
  def create
    @multiple_loan_payment_processing = Loans::MultiplePaymentProcessing.new(payment_params)
    if @multiple_loan_payment_processing.valid?
      @multiple_loan_payment_processing.create_voucher!
      redirect_to multiple_loan_payment_voucher_path(@multiple_loan_payment_processing.find_voucher), notice: 'created successfully'
    else
      redirect_to new_loan_multiple_payment_line_item_url, alert: 'Cannot proceed. Please fill up all the form correctly.'
    end
  end

  private
  def payment_params
    params.require(:loans_multiple_payment_processing).
    permit(:cart_id, :reference_number, :date, :description, :account_number, :employee_id)
  end
end
