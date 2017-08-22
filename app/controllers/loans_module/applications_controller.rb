module LoansModule 
	class ApplicationsController < ApplicationController
		def new 
			@loan_product = LoansModule::LoanProduct.find(params[:loan_product_id])
		end 
	end 
end