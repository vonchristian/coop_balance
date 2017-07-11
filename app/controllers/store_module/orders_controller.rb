module StoreModule
  class OrdersController < ApplicationController
    def new
      @cart = current_cart
      @order = StoreModule::Order.new
    end
    def index
      @orders = StoreModule::Order.all.includes(:member, :official_receipt)
    end
    def create
      @order = StoreModule::Order.create(order_params)
      if @order.valid?
        @order.add_line_items_from_cart(current_cart)
        OfficialReceipt.generate_number_for(@order)
        redirect_to store_index_url, notice: "Order saved successfully"
      else
        render @order
      end
    end
    def show
      @order = StoreModule::Order.find(params[:id])
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
      params.require(:store_module_order).permit(:member_id, :date, :payment_type)
    end
  end
end