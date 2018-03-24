module StoreFrontModule
  module Orders
    class PurchasesController < ApplicationController
      def new
        if params[:search].present?
          @products = StoreFrontModule::Product.text_search(params[:search]).all
        end
        @cart = current_cart
        @purchase_order_line_item = StoreFrontModule::LineItems::PurchaseOrderLineItemProcessing.new
        @purchase_order = StoreFrontModule::Orders::PurchaseOrderProcessing.new
        @purchase_order_line_items = @cart.purchase_order_line_items.order(created_at: :desc)
      end
      def index
        @purchase_orders = StoreFrontModule::Orders::PurchaseOrder.
        includes(:commercial_document, :voucher, :line_items, :employee).all.
        paginate(page: params[:page], per_page: 30)
      end
      def show
        @purchase_order = StoreFrontModule::Orders::PurchaseOrder.find(params[:id])
        @supplier = @purchase_order.commercial_document
      end
      def create
        @purchase_order = StoreFrontModule::Orders::PurchaseOrderProcessing.new(purchase_order_params)
        if @purchase_order.valid?
          @purchase_order.process!
          redirect_to store_front_module_purchases_url, notice: "Purchase order processed successfully"
        else
          redirect_to new_store_front_module_purchase_line_item_path
        end
      end

      private
      def purchase_order_params
        params.require(:store_front_module_orders_purchase_order_processing).
        permit(:supplier_id, :voucher_id, :cart_id, :employee_id, :date, :description)
      end
    end
  end
end
