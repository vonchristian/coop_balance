class LoanMultiplePaymentLineItemsController < ApplicationController
  def new
    if params[:search].present?
      @pagy, @loans = pagy(current_office.loans.text_search(params[:search]))
    else
      @pagy, @loans = pagy(current_office.loans.includes(:borrower, :loan_product, :receivable_account, :interest_revenue_account, :penalty_revenue_account))
    end
    @line_item = Loans::MultiplePayment.new
    @loans_with_payments = current_office.loans.where(id: ::Loans::MultiplePaymentFinder.new(cart: current_cart).loan_ids)
    @multiple_loan_payment_processing = Loans::MultiplePaymentProcessing.new
  end
end
