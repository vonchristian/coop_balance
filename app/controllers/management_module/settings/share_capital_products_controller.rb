module ManagementModule
  module Settings
    class ShareCapitalProductsController < ApplicationController
      respond_to :html, :json

      def new
        @share_capital_product = current_cooperative.share_capital_products.build
        respond_modal_with @share_capital_product
      end

      def create
        @share_capital_product = current_cooperative.share_capital_products.create(share_capital_product_params)
        respond_modal_with @share_capital_product,
          location: management_module_settings_cooperative_products_url
      end

      private
      def share_capital_product_params
        params.require(:cooperatives_share_capital_product).permit(
                        :name,
                        :cost_per_share,
                        :minimum_number_of_subscribed_share,
                        :minimum_number_of_paid_share,
                        :default_product,
                        :equity_account_id,
                        :minimum_balance)
      end
    end
  end
end
