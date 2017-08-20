module LoansModule 
	class LoanProductChargesController < ApplicationController
		def create
			@loan_product_charge = LoanProductCharge.create(loan_product_charge_params)
			@loan_product_charge.save 
			redirect_to loans_module_loan_product_url(@loan_product_charge.loan_product), notice: "Charge created successfully"
		end 

		private 
		def loan_product_charge_params
			params.require(:loan_product_charge).permit(:loan_product_id, :charge_id)
		end 
	end 
end