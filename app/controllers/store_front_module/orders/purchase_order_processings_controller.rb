module StoreFrontModule
  class PurchaseOrderProcessingsController < ApplicationController
    def new
      @purchase_order = StoreFrontModule::Orders::PurchaseOrderProcessing.new
       @cart = current_cart
    end
    def create
      @purchase_order = StoreFrontModule::Orders::PurchaseOrderProcessing.new(purchase_order_params)
      if @purchase_order.valid?
        @purchase_order.process!
        redirect_to store_front_module_purchase_orders_url, notice: "successfully"
      else
        render :new
      end
    end

    private
    def purchase_order_params
      params.require(:store_front_module_orders_purchase_order_processing).permit(:commercial_document_id, :commercial_document_type, :voucher_id, :cart_id, :employee_id)
    end
  end
end
