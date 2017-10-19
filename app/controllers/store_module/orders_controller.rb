module StoreModule
  class OrdersController < ApplicationController
    def new
      @cart = current_cart
      @order = StoreModule::Order.new
    end
    def index
      @orders = StoreModule::Order.all.includes(:member, :official_receipt).order(date: :desc)
    end
    def create
      @order = StoreModule::Order.create(order_params)
      if @order.save
        @order.add_line_items_from_cart(current_cart)
        if @order.cash?
          OfficialReceipt.generate_number_for(@order)
        end
        redirect_to store_index_url, notice: "Order saved successfully"
        @order.create_entry
      else
        render @order
      end
    end
    def show
      @order = StoreModule::Order.includes(line_items: [:product_stock, :product]).find(params[:id])
      @line_items = @order.line_items
      respond_to do |format|
        format.html
        format.pdf do
          pdf = OrderPdf.new(@order, @line_items, view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Invoice.pdf"
          pdf.print
        end
      end
    end

    private
    def order_params
      params.require(:store_module_order).permit(:customer_id, :date, :payment_type, :cash_tendered, :order_change, :total_cost, :employee_id)
    end
  end
end