module Loans
  class PaymentVouchersController < ApplicationController
    def show
      @loan = current_cooperative.loans.find(params[:loan_id])
      @voucher = current_cooperative.vouchers.find(params[:id])
      @schedule_id = params[:schedule_id]
    end
  end
end
