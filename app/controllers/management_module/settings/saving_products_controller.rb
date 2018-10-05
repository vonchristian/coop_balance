module ManagementModule
  module Settings
    class SavingProductsController < ApplicationController
      def new
        @saving_product = CoopServicesModule::SavingProduct.new
      end
      def create
        @saving_product =  CoopServicesModule::SavingProduct.create(saving_product_params)
        if @saving_product.valid?
          @saving_product.save
          redirect_to management_module_settings_cooperative_products_url, notice: "Saving Product created successfully"
        else
          render :new
        end
      end

      private
      def saving_product_params
        params.require(:coop_services_module_saving_product).permit(:name, :interest_rate, :interest_recurrence, :account_id, :interest_expense_account_id, :closing_account_id, :minimum_balance)
      end
    end
  end
end
