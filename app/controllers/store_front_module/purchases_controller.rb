module StoreFrontModule
  class PurchasesController < ApplicationController
    def new
      @line_item = StoreFrontModule::PurchaseLineItemProcessing.new
      @cart = current_cart
      @product = StoreFrontModule::Product.find(params[:product_search][:product_id]) if params[:product_search].present?
      @supplier = Supplier.text_search(params[:supplier_search]).last
    end

    def create
      @line_item = StoreFrontModule::PurchaseLineItemProcessing.new(purchase_params)
      if @line_item.valid?
        @line_item.process!
        redirect_to new_store_front_module_purchase_url(@supplier), notice: 'Stock added successfully'
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def purchase_params
      params.require(:store_front_module_purchase_line_item_processing).permit(:commercial_document_id, :commercial_document_type, :unit_of_measurement_id, :quantity, :cart_id, :product_id, :unit_cost, :total_cost, :cart_id, :barcode)
    end
  end
end
