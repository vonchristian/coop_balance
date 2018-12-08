module LoansModule
  module LoanApplications
    class VoucherConfirmationsController < ApplicationController
      def create
        @loan_application = current_cooperative.loan_applications.find(params[:loan_application_id])
        @voucher = current_cooperative.vouchers.find(params[:voucher_id])
        @employee = current_user
        ActiveRecord::Base.transaction do
          LoansModule::LoanCreationProcessing.new(loan_application: @loan_application, employee: current_user).process!
          @loan = LoansModule::LoanCreationProcessing.new(loan_application: @loan_application, employee: current_user).find_loan
          LoansModule::LoanApplications::EntryProcessing.new(
          loan:             @loan,
          voucher:          @voucher,
          loan_application: @loan_application,
          employee:         @employee).process!
          redirect_to loan_url(@loan), notice: 'Loan disbursed succesfully.'
        end
      end
    end
  end
end
