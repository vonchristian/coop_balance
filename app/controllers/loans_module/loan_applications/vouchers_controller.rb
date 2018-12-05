module LoansModule
  module LoanApplications
    class VouchersController < ApplicationController
      def new
        @loan_application = current_cooperative.loan_applications.find(params[:loan_application_id])
        @borrower = @loan_application.borrower
        @share_capitals = @borrower.share_capitals
        @savings_accounts = @borrower.savings
        @voucher = LoansModule::LoanApplications::VoucherProcessing.new
      end
      def create
        @loan_application = current_cooperative.loan_applications.find(params[:loan_application_id])
        @share_capitals = @loan_application.borrower.share_capitals
        @voucher = LoansModule::LoanApplications::VoucherProcessing.new(voucher_params)
        if @voucher.valid?
          @voucher.process!
          redirect_to loans_module_loan_applications_url, notice: "Loan application saved successfully."
        else
          render :new
        end
      end
      def show
        @loan_application = current_cooperative.loan_applications.find(params[:loan_application_id])
        @voucher = @loan_application.voucher
      end

      def destroy
        @loan_application = current_cooperative.loan_applications.find(params[:loan_application_id])
        @voucher = @loan_application.voucher
        @loan = @loan_application.loan
        @loan_application.destroy
        @voucher.destroy
        if !@loan.disbursement_voucher.disbursed?
          @loan.destroy
        end
        redirect_to loans_module_loan_applications_url, notice: "Voucher cancelled succesfully."
      end


      private
      def voucher_params
        params.require(:loans_module_loan_applications_voucher_processing).
        permit(:loan_application_id, :preparer_id, :date, :description, :number, :reference_number,
          :account_number, :voucher_account_number, :cash_account_id, :borrower_id, :borrower_type, :net_proceed)
      end
    end
  end
end
