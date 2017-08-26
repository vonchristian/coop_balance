module LoansModule 
	class DisbursementVouchersController < ApplicationController
		def new 
			@loan = LoansModule::Loan.find(params[:loan_id])
			@voucher = @loan.build_cash_disbursement_voucher
		end 
		def create
			@loan = LoansModule::Loan.find(params[:loan_id])
			@voucher = @loan.create_cash_disbursement_voucher(voucher_params)
			if @voucher.valid?
				@voucher.save 
				redirect_to loans_module_loan_url(@loan), notice: "Cash disbursement voucher created successfully."
			else 
				render :new 
			end
		end 
		def show 
			@loan = LoansModule::Loan.find(params[:loan_id])
			@voucher = @loan.cash_disbursement_voucher
			respond_to do |format|
				format.pdf do 
					pdf = LoansModule::LoanDisbursementVoucherPdf.new(@loan, @voucher, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Loan Disbursement Voucher.pdf"
        end
      end
		end 

		private 
		def voucher_params
			params.require(:voucher).permit(:number)
		end 
	end 
end 