module ManagementModule
  module Settings
    module LoanProducts
      class ChargesController < ApplicationController
        respond_to :html, :json

        def new
          @loan_product = current_cooperative.loan_products.find(params[:loan_product_id])
          @charge = @loan_product.loan_product_charges.build
          respond_modal_with @charge
        end

        def create
          @loan_product = current_cooperative.loan_products.find(params[:loan_product_id])
          @charge = @loan_product.loan_product_charges.build(charge_params)
          @charge.save
          respond_modal_with @charge,
                             location: management_module_settings_cooperative_products_url
        end

        def edit
          @loan_product = current_cooperative.loan_products.find(params[:loan_product_id])
          @charge = @loan_product.loan_product_charges.find(params[:id])
          respond_modal_with @charge
        end

        def update
          @loan_product = current_cooperative.loan_products.find(params[:loan_product_id])
          @charge = @loan_product.loan_product_charges.find(params[:id])
          @charge.update(charge_params)
          respond_modal_with @charge,
                             location: management_module_settings_cooperative_products_url
        end

        private

        def charge_params
          params.require(:loans_module_loan_products_loan_product_charge).permit(:charge_type, :name, :rate, :amount, :account_id)
        end
      end
    end
  end
end
