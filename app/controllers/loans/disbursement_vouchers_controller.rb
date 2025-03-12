module Loans
  class DisbursementVouchersController < ApplicationController
    def new
      @loan = current_cooperative.loans.find(params[:loan_id])
      @voucher = Vouchers::LoanDisbursementVoucher.new
    end

    def create
      @loan = current_cooperative.loans.find(params[:loan_id])
      @voucher = Vouchers::LoanDisbursementVoucher.create(voucher_params)
      @voucher.payee = @loan
      if @voucher.valid?
        @voucher.save
        @voucher.add_amounts_from(@loan)
        redirect_to loan_disbursements_url(@loan), notice: "Voucher created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def show
      @loan = current_cooperative.loans.find(params[:loan_id])
      @voucher = @loan.disbursement_voucher
      respond_to do |format|
        format.pdf do
          pdf = Vouchers::LoanVoucherPdf.new(@loan, @voucher, view_context)
          send_data pdf.render, type: "application/pdf", disposition: "inline", file_name: "Loan Disbursement Voucher.pdf"
        end
      end
    end

    private

    def voucher_params
      params.require(:vouchers_loan_disbursement_voucher).permit(:number, :date, :description, :number, :preparer_id, :cash_account_id)
    end
  end
end
