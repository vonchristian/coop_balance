module StoreFrontModule
  module Suppliers
    class PurchaseDeliveriesController < ApplicationController
      def index
        @supplier = Supplier.find(params[:supplier_id])
        @purchase_orders = @supplier.purchase_orders.paginate(page: params[:page], per_page: 35)
      end
      def new
        @supplier = Supplier.find(params[:supplier_id])
        @line_item = StoreFrontModule::LineItems::PurchaseOrderLineItemProcessing.new
        @cart = current_cart
        @product = StoreFrontModule::Product.text_search(params[:search]).last
        @voucher = @supplier.vouchers.text_search(params[:voucher_search]).last
        @purchase_order_processing = StoreFrontModule::Orders::PurchaseOrderProcessing.new
      end
      def create
        @supplier = Supplier.find(params[:supplier_id])
        @line_item = StoreFrontModule::LineItems::PurchaseOrderLineItemProcessing.new(purchase_params)
        if @line_item.valid?
          @line_item.process!
          redirect_to new_supplier_purchase_url(@supplier), notice: "Stock added successfully"
        else
          render :new, status: :unprocessable_entity
        end
      end

      private
      def purchase_params
        params.require(:store_front_module_line_items_purchase_order_line_item_processing).permit(:commercial_document_id, :commercial_document_type, :unit_of_measurement_id, :quantity, :cart_id, :product_id, :unit_cost, :total_cost, :cart_id, :barcode)
      end
    end
  end
end
