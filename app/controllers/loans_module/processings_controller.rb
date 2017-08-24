module LoansModule 
	class ProcessingsController < ApplicationController
		def create 
			@loan = LoansModule::Loan.find(params[:loan_id])
			@loan.processing!
			redirect_to loans_module_loan_url(@loan), notice: "Loan is on process" 
		end 
	end 
end 