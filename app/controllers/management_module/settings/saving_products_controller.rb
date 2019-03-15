module ManagementModule
  module Settings
    class SavingProductsController < ApplicationController
      respond_to :html, :json

      def new
        @saving_product = current_cooperative.saving_products.build
        respond_modal_with @saving_product
      end

      def create
        @saving_product =  current_cooperative.saving_products.create(saving_product_params)
        respond_modal_with @saving_product,
          location: management_module_settings_cooperative_products_url,
          notice: "Saving Product created successfully"
      end

      def edit
        @saving_product = current_cooperative.saving_products.find(params[:id])
        respond_modal_with @saving_product
      end

      def update
        @saving_product = current_cooperative.saving_products.find(params[:id])
        @saving_product.update(saving_product_params)
        respond_modal_with @saving_product,
          location: management_module_settings_cooperative_products_url
      end

      private
      def saving_product_params
        params.require(:coop_services_module_saving_product).permit(
          :name,
          :interest_rate,
          :office_id,
          :interest_recurrence,
          :account_id,
          :interest_expense_account_id,
          :closing_account_id,
          :closing_account_fee,
          :dormancy_number_of_days,
          :minimum_balance)
      end
    end
  end
end
