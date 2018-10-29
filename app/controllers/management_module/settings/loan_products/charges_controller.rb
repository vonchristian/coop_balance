module ManagementModule
  module Settings
    module LoanProducts
      class ChargesController < ApplicationController
        def new
          @loan_product = current_cooperative.loan_products.find(params[:loan_product_id])
          @charge = @loan_product.loan_product_charges.build
        end
        def create
          @loan_product = current_cooperative.loan_products.find(params[:loan_product_id])
          @charge = @loan_product.loan_product_charges.build(charge_params)
          if @charge.valid?
            @charge.save
            redirect_to management_module_settings_cooperative_products_url, notice: "saved successfully"
          else
            render :new
          end
        end

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
    			params.require(:loans_module_loan_products_loan_product_charge).permit(:charge_type, :name, :rate, :amount, :account_id)
    		end
      end
    end
  end
end
