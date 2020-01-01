module Loans
  class PaymentVouchersController < ApplicationController
    def show
      @loan = current_office.loans.find(params[:loan_id])
      @voucher = current_office.vouchers.find(params[:id])
    end
  end
end
