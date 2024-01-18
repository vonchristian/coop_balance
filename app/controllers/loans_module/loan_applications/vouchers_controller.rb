module LoansModule
  module LoanApplications
    class VouchersController < ApplicationController
      def new
        @loan_application = current_cooperative.loan_applications.includes(:loan_product).find(params[:loan_application_id])
        redirect_to loans_module_loan_applications_url(@loan_application) if @loan_application.voucher.present?
        @borrower         = @loan_application.borrower
        @share_capitals   = @borrower.share_capitals
        @savings_accounts = @borrower.savings
        @previous_loans   = @borrower.loans.includes(:loan_product)
        @voucher          = LoansModule::LoanApplications::VoucherProcessing.new
      end

      def create
        @loan_application = current_cooperative.loan_applications.find(params[:loan_application_id])
        @share_capitals = @loan_application.borrower.share_capitals
        @voucher = LoansModule::LoanApplications::VoucherProcessing.new(voucher_params)
        if @voucher.process!
          redirect_to loans_module_loan_application_url(@loan_application), notice: 'Loan application saved successfully.'
        else
          redirect_to new_loans_module_loan_application_voucher_url(@loan_application), alert: 'Unable to proceed. Please fill up the required fields.'
        end
      end

      def show
        @loan_application = current_cooperative.loan_applications.find(params[:loan_application_id])
        @voucher = @loan_application.voucher
        respond_to do |format|
          format.html
          format.pdf do
            pdf = VoucherPdf.new(
              voucher: @voucher,
              view_context: view_context
            )
            send_data pdf.render, type: 'application/pdf', disposition: 'inline', file_name: 'Voucher.pdf'
          end
        end
      end

      def destroy
        @loan_application = current_cooperative.loan_applications.find(params[:loan_application_id])
        @voucher = @loan_application.voucher
        @loan = @loan_application.loan
        @loan_application.destroy
        @voucher.destroy
        @loan.destroy unless @loan.disbursement_voucher.disbursed?
        redirect_to loans_module_loan_applications_url, notice: 'Voucher cancelled succesfully.'
      end

      private

      def voucher_params
        params.require(:loans_module_loan_applications_voucher_processing)
              .permit(:loan_application_id, :preparer_id, :date, :description, :number, :reference_number,
                      :account_number, :voucher_account_number, :cash_account_id, :borrower_id, :borrower_type, :net_proceed)
      end
    end
  end
end
