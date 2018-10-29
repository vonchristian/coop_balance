module LoanApplications
  class VoucherConfirmationsController < ApplicationController
    def create
      @loan_application = current_cooperative.loan_applications.find(params[:loan_application_id])
      @voucher = current_cooperative.vouchers.find(params[:voucher_id])
      LoansModule::LoanCreationProcessing.new(loan_application: @loan_application, account_number: SecureRandom.uuid).process!
      @loan = LoansModule::LoanCreationProcessing.new(loan_application: @loan_application).find_loan
      LoansModule::LoanApplications::EntryProcessing.new(loan: @loan, voucher: @voucher, employee: @employee).process!
      redirect_to "/", notice: 'Loan disbursed succesfully.'
    end
  end
end
