module StoreFrontModule
  module Suppliers
    class PurchaseLineItemsController < ApplicationController
      def new
        @supplier = current_cooperative.suppliers.find(params[:supplier_id])
        @products = current_cooperative.products.text_search(params[:search]).all.paginate(page: params[:page], per_page: 30)
        @line_items = current_cooperative.purchase_line_items.text_search(params[:search]).paginate(page: params[:page], per_page: 30)
        @cart = current_cart
        @purchase_line_item = StoreFrontModule::LineItems::PurchaseLineItemProcessing.new
        @purchase_order = StoreFrontModule::Orders::PurchaseOrderProcessing.new
        @purchase_line_items = @cart.purchase_line_items.includes(:unit_of_measurement, :product).order(created_at: :desc)
      end

      def create
        @supplier = current_cooperative.suppliers.find(params[:supplier_id])
        @cart = current_cart
        @purchase_order_line_item = StoreFrontModule::LineItems::PurchaseLineItemProcessing.new(line_item_params)
        if @purchase_order_line_item.valid?
          @purchase_order_line_item.process!
          redirect_to new_store_front_module_purchase_line_item_url, notice: 'Added to cart.'
        else
          render :new, status: :unprocessable_entity
        end
      end
    end
  end
end
