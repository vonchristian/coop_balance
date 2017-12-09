module LoansModule
	class LoanProductChargesController < ApplicationController
		def new
			@loan_product = LoansModule::LoanProduct.friendly.find(params[:loan_product_id])
			@loan_product_charge = @loan_product.loan_product_charges.build
			@loan_product_charge.build_charge
		end

		def create
			@loan_product = LoansModule::LoanProduct.friendly.find(params[:loan_product_id])
			@loan_product_charge = @loan_product.loan_product_charges.create(loan_product_charge_params)
			if @loan_product_charge.save
			  redirect_to loans_module_loan_product_url(@loan_product), notice: "Charge created successfully"
			else
				render :new
			end
		end

		private
		def loan_product_charge_params
			params.require(:loan_product_charge).permit(charge_attributes: [:name, :charge_type, :percent, :amount, :account_id, :minimum_loan_amount, :maximum_loan_amount, :depends_on_loan_amount])
		end
	end
end
