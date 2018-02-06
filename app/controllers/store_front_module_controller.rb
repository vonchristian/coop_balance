class StoreFrontModuleController < ApplicationController
  def index
    respond_to do |format|
      if params[:search].present?
        @products = StoreFrontModule::Product.text_search(params[:search]).all
        @line_items = StoreFrontModule::LineItems::PurchaseOrderLineItem.text_search(params[:search])
      end
      @cart = current_cart
      @line_item = StoreFrontModule::LineItems::SalesOrderLineItemProcessing.new
      @sales_order = StoreFrontModule::Orders::SalesOrderProcessing.new
      @sales_order_line_items = @cart.sales_order_line_items.order(created_at: :desc)
      format.html
    end
  end
end
