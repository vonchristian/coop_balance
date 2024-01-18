module StoreFrontModule
  module LineItems
    class CreditSalesLineItemsController < ApplicationController
      def new
        if Member.find_by(id: params[:customer_id]).present?
          @customer = Member.find_by(id: params[:customer_id])
        elsif User.find_by(id: params[:customer_id]).present?
          @customer = User.find_by(id: params[:customer_id])
        end
        if params[:search].present?
          @products = StoreFrontModule::Product.text_search(params[:search]).all
          @line_items = StoreFrontModule::LineItems::PurchaseLineItem.text_search(params[:search])
        end
        @cart = current_cart
        @line_item = StoreFrontModule::LineItems::SalesLineItemProcessing.new
        @credit_sales_order = StoreFrontModule::Orders::CreditSalesOrderProcessing.new
        @sales_line_items = @cart.sales_line_items.order(created_at: :desc)
      end

      def create
        @cart = current_cart
        @line_item = StoreFrontModule::LineItems::SalesLineItemProcessing.new(line_item_params)
        if @line_item.valid?
          @line_item.process!
          redirect_to new_store_front_module_customer_credit_sales_line_item_url, notice: 'Added to cart.'
        else
          redirect_to new_store_front_module_customer_credit_sales_line_item_url, alert: 'Exceeded available quantity'
        end
      end

      def destroy
        @cart = current_cart
        @product = StoreFrontModule::Product.find_by(id: params[:id])
        @cart.line_items.where(product: @product).destroy_all if @product.present?
        @line_item = StoreFrontModule::LineItems::SalesLineItem.find_by(id: params[:id])
        @line_item.destroy if @line_item.present?
        redirect_to new_store_front_module_customer_credit_sales_line_item_url
      end

      private

      def line_item_params
        params.require(:store_front_module_line_items_sales_line_item_processing).permit(:commercial_document_id, :commercial_document_type, :unit_of_measurement_id, :quantity, :cart_id, :product_id, :unit_cost, :total_cost, :cart_id, :barcode, :referenced_line_item_id)
      end
    end
  end
end
