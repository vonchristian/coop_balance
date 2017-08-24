module LoansModule 
	class ChargesController < ApplicationController
		def new 
			@charge = Charge.new 
		end 
		def create 
			@charge = Charge.create(charge_params)
			if @charge.save 
				redirect_to loans_module_settings_url, notice: "Charge created successfully."
			else 
				render :new 
			end 
		end 

		private
		def charge_params
			params.require(:charge).permit(:name, :charge_type, :percent, :amount, :debit_account_id, :credit_account_id)
		end 
	end 
end