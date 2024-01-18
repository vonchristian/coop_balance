module Members
  class CreditSalesLineItemsController < ApplicationController
    def new
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @sales_line_item = StoreFrontModule::LineItems::SalesLineItemProcessing.new
      @cart = current_cart
      @sales_order = StoreFrontModule::Orders::SalesOrderProcessing.new
      @sales_line_items = @cart.sales_line_items.order(created_at: :desc)
      return if params[:search].blank?

      @products = current_cooperative.products.text_search(params[:search]).all
      @purchase_line_items = current_cooperative.purchase_line_items.processed.text_search(params[:search])
    end

    def create
      @cart = current_cart
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @sales_line_item = StoreFrontModule::LineItems::SalesLineItemProcessing.new(line_item_params)
      if @sales_line_item.valid?
        @sales_line_item.process!
        redirect_to new_member_credit_sales_line_item_url(@member), notice: 'Added to cart.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @line_item = StoreFrontModule::LineItems::SalesLineItem.find_by(id: params[:id])
      @line_item.destroy
      redirect_to new_member_credit_sales_line_item_url(@member)
    end

    private

    def line_item_params
      params.require(:store_front_module_line_items_sales_line_item_processing)
            .permit(:unit_of_measurement_id,
                    :quantity,
                    :unit_cost,
                    :total_cost,
                    :product_id,
                    :barcode,
                    :cart_id,
                    :purchase_line_item_id)
    end
  end
end
