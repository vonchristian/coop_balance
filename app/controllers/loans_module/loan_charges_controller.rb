module LoansModule 
	class LoanChargesController < ApplicationController
		def destroy 
			@loan_charge = LoansModule::LoanCharge.find(params[:id])
			@loan_charge.destroy 
			redirect_to loans_module_loan_application_url(@loan_charge.loan), alert: 'Removed successfully'
		end 
	end 
end 