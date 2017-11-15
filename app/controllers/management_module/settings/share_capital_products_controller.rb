module ManagementModule
  module Settings
    class ShareCapitalProductsController < ApplicationController
      def new
        @share_capital_product = CoopServicesModule::ShareCapitalProduct.new
      end
      def create
        @share_capital_product = CoopServicesModule::ShareCapitalProduct.create(share_capital_product_params)
        if @share_capital_product.valid?
          @share_capital_product.save
          redirect_to management_module_settings_url, notice: "Share Capital Product created succesfully."
        else
          render :new
        end
      end

      private
      def share_capital_product_params
        params.require(:coop_services_module_share_capital_product).permit(:name, :cost_per_share, :minimum_number_of_subscribed_share, :minimum_number_of_paid_share, :default_product, :account_id)
      end
    end
  end
end
