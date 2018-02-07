module StoreFrontModule
  module Orders
    class PurchaseOrderProcessingsController < ApplicationController
      def create
        @purchase_order = StoreFrontModule::Orders::PurchaseOrderProcessing.new(purchase_order_params)
        if @purchase_order.valid?
          @purchase_order.process!
          redirect_to "/", notice: "successfully"
        else
          render :new
        end
      end

      private
      def purchase_order_params
        params.require(:store_front_module_orders_purchase_order_processing).permit(:supplier_id, :voucher_id, :cart_id, :employee_id, :date)
      end
    end
  end
end
