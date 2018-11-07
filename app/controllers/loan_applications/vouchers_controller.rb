module LoanApplications
  class VouchersController < ApplicationController
    def show
      @loan_application = current_cooperative.loan_applications.find(params[:loan_application_id])
      @voucher = @loan_application.voucher
    end
  end
end
