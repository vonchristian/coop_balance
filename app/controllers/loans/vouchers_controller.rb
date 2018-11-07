module Loans
  class VouchersController < ApplicationController
    def show
      @loan = current_cooperative.loans.find(params[:loan_id])
      @voucher = current_cooperative.vouchers.find(params[:id])
    end
  end
end
