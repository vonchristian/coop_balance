module Loans
  class PaymentVouchersController < ApplicationController
    def show
      @loan = LoansModule::Loan.find(params[:loan_id])
      @voucher = Voucher.find(params[:id])
    end
  end
end
