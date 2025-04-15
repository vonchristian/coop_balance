module StoreFrontModule
  module LineItems
    class PurchaseLineItemsController < ApplicationController
      def new
        @products = current_cooperative.products.text_search(params[:search]).all.paginate(page: params[:page], per_page: 30)
        @line_items = current_store_front.purchase_line_items.text_search(params[:search]).paginate(page: params[:page], per_page: 30)
        @cart = current_cart
        @purchase_line_item = StoreFrontModule::LineItems::PurchaseLineItemProcessing.new
        @purchase_order = StoreFrontModule::Orders::PurchaseOrderProcessing.new
        @purchase_line_items = @cart.purchase_line_items.includes(:unit_of_measurement, :product).order(created_at: :desc)
        @vouchers = TreasuryModule::Voucher.includes(entry: [ :debit_amounts ]).unused
        @suppliers = current_cooperative.suppliers
      end

      def create
        @cart = current_cart
        @purchase_order_line_item = StoreFrontModule::LineItems::PurchaseLineItemProcessing.new(line_item_params)
        if @purchase_order_line_item.valid?
          @purchase_order_line_item.process!
          redirect_to new_store_front_module_purchase_line_item_url, notice: "Added to cart."
        else
          render :new, status: :unprocessable_entity
        end
      end

      def destroy
        @cart = current_cart
        @line_item = StoreFrontModule::LineItems::PurchaseLineItem.find(params[:id])
        @line_item.destroy
        redirect_to new_store_front_module_purchase_line_item_url
      end

      private

      def line_item_params
        params.require(:store_front_module_line_items_purchase_line_item_processing)
              .permit(:unit_of_measurement_id,
                      :quantity,
                      :unit_cost,
                      :total_cost,
                      :product_id,
                      :referenced_line_item_id,
                      :barcode,
                      :cart_id,
                      :expiry_date)
      end
    end
  end
end
