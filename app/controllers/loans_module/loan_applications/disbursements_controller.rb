module LoansModule
  module LoanApplications
    class DisbursementsController < ApplicationController
      def new
        @loan_application = current_office.loan_applications.find(params[:loan_application_id])
        @voucher = @loan_application.voucher
        @disbursement = LoansModule::LoanApplications::Disbursement.new
      end
    end
  end
end
