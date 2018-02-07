module StoreFrontModule
  module Orders
    class PurchaseOrdersController < ApplicationController
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
        @purchase_orders = StoreFrontModule::Orders::PurchaseOrder.all.paginate(page: params[:page], per_page: 30)
      end
      def show
        @purchase_order = StoreFrontModule::Orders::PurchaseOrder.find(params[:id])
        @supplier = @purchase_order.commercial_document
      end
    end
  end
end
