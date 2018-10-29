module LoanApplications
  class VouchersController < ApplicationController
    def show
      @loan_application = LoansModule::LoanApplication.find(params[:loan_application_id])
      @voucher = @loan_application.voucher
    end
  end
end 
