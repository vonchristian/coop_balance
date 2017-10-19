module ManagementModule
  module Settings
    class ShareCapitalProductsController < ApplicationController
      def new
        @share_capital_product = ManagementModule::ShareCapitalProductForm.new
      end
      def create
        @share_capital_product = ManagementModule::ShareCapitalProductForm.new(share_capital_product_params)
        if @share_capital_product.valid?
          @share_capital_product.register
          redirect_to management_module_settings_url, notice: "Share Capital Product created succesfully."
        else
          render :new
        end
      end

      private
      def share_capital_product_params
        params.require(:management_module_share_capital_product_form).permit(:name, :cost_per_share, :share_count)
      end
    end
  end
end
