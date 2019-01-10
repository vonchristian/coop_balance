module TimeDeposits
	class WithdrawalVouchersController < ApplicationController
		def show
			@time_deposit = current_cooperative.time_deposits.find(params[:time_deposit_id])
			@voucher = Voucher.find(params[:id])
			respond_to do |format|
	      format.html
	      format.pdf do
	        pdf = TimeDeposits::WithdrawalVoucherPdf.new(
	        	time_deposit: @time_deposit,
	          voucher: @voucher,
	          view_context: view_context)
	        send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Voucher.pdf"
	      end
	    end
		end
	end
end