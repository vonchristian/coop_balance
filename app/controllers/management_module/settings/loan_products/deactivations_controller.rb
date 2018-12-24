module ManagementModule
  module Settings
    module LoanProducts
      class DeactivationsController < ApplicationController
        def create
          @loan_product = current_cooperative.loan_products.find(params[:loan_product_id])
          @loan_product.active = false
          @loan_product.save
          redirect_to management_module_settings_cooperative_products_url, alert: "Deactivated successfully."
        end
      end
    end
  end
end