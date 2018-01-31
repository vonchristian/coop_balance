module Suppliers
  class PurchasesController < ApplicationController
    def index
      @supplier = Supplier.find(params[:supplier_id])
    end
    def new
      @supplier = Supplier.find(params[:supplier_id])
      @line_item = StoreFrontModule::PurchaseLineItemProcessing.new
      @cart = current_cart
      @product = StoreFrontModule::Product.text_search(params[:search]).last
      @voucher = @supplier.vouchers.text_search(params[:voucher_search]).last
      @order_processing = StoreFrontModule::PurchaseOrderProcessing.new
    end
    def create
      @supplier = Supplier.find(params[:supplier_id])
      @line_item = StoreFrontModule::PurchaseLineItemProcessing.new(purchase_params)
      if @line_item.valid?
        @line_item.process!
        redirect_to new_supplier_purchase_url(@supplier), notice: "Stock added successfully"
      else
        render :new
      end
    end

    private
    def purchase_params
      params.require(:store_front_module_purchase_line_item_processing).permit(:commercial_document_id, :commercial_document_type, :unit_of_measurement_id, :quantity, :cart_id, :product_id, :unit_cost, :total_cost, :cart_id, :barcode)
    end
  end
end
