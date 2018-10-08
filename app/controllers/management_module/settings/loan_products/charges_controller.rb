module ManagementModule
  module Settings
    module LoanProducts
      class ChargesController < ApplicationController
        def edit
          @loan_product = LoansModule::LoanProduct.find(params[:loan_product_id])
    			@charge = @loan_product.charges.find(params[:id])
    		end
    		def update
          @loan_product = LoansModule::LoanProduct.find(params[:loan_product_id])
    			@charge = @loan_product.charges.find(params[:id])
    			@charge.update(charge_params)
    			if @charge.save
    				redirect_to management_module_settings_cooperative_products_url, notice: "Charge updated successfully."
    			else
    				render :edit
    			end
    		end

    		private
    		def charge_params
    			params.require(:charge).permit(:name, :charge_type, :percent, :amount, :account_id)
    		end
      end
    end
  end
end
