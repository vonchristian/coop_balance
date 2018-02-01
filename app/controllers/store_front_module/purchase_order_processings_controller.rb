module StoreFrontModule
  class PurchaseOrderProcessingsController < ApplicationController
    def new
      @order = StoreFrontModule::PurchaseOrderProcessingForm.new
       @cart = current_cart
    end
    def create
      @purchase_order = StoreFrontModule::PurchaseOrderProcessing.new(purchase_order_params)
      if @purchase_order.valid?
        @purchase_order.process!
        redirect_to store_front_module_purchases_url, notice: "successfully"
      else
        render :new
      end
    end

    private
    def purchase_order_params
      params.require(:store_front_module_purchase_order_processing).permit(:supplier_id, :voucher_id, :cart_id)
    end
  end
end
