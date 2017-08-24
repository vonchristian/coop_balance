module LoansModule
	class AdditionalChargesController < ApplicationController
		def new 
			@loan = LoansModule::Loan.find(params[:loan_id])
			@additional_charge = @loan.loan_additional_charges.build 
		end 
		def create 
			@loan = LoansModule::Loan.find(params[:loan_id])
			@additional_charge = @loan.loan_additional_charges.create(additional_charge_params)
			if @additional_charge.valid?
				@additional_charge.save 
				redirect_to loans_module_loan_application_url(@loan), notice: "Additional Charge created successfully"
			else 
				render :new 
			end 
		end 

		private
		def additional_charge_params
			params.require(:loan_additional_charge).permit(:name, :amount)
		end 
	end 
end 