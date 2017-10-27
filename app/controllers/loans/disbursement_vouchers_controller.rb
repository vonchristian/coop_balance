module Loans
	class DisbursementVouchersController < ApplicationController
		def new 
			@loan = LoansModule::Loan.find(params[:loan_id])
			@voucher = Vouchers::LoanVoucher.new
		end 
		def create
			@loan = LoansModule::Loan.find(params[:loan_id])
			@voucher = Vouchers::LoanVoucher.create(voucher_params)
      @voucher.voucherable = @loan
      @voucher.payee = @loan.borrower
			if @voucher.valid?
				@voucher.save 
        @voucher.add_amounts_from(@loan)
				redirect_to loan_url(@loan), notice: "Voucher created successfully."
			else 
				render :new 
			end
		end 
		def show 
			@loan = LoansModule::Loan.find(params[:loan_id])
			@voucher = @loan.cash_disbursement_voucher
			respond_to do |format|
				format.pdf do 
					pdf = Vouchers::LoanVoucherPdf.new(@loan, @voucher, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Loan Disbursement Voucher.pdf"
        end
      end
		end 

		private 
		def voucher_params
			params.require(:voucher).permit(:number, :date, :description)
		end 
	end 
end 