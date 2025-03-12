module StoreFrontModule
  class OrdersController < ApplicationController
    def index
      @orders = StoreFrontModule::Order.includes(:customer).order(date: :desc)
    end

    def new
      @cart = current_cart
      @order = StoreFrontModule::OrderProcessing.new
      @customer = StoreFrontModule::CheckoutForm.new.find_customer(params[:customer_id])
    end

    def create
      @order = StoreFrontModule::OrderProcessing.new(order_params)
      if @order.valid?
        @order.add_line_items_from_cart(current_cart)
        OfficialReceipt.generate_number_for(@order) if @order.cash?
        redirect_to store_index_url, notice: "Order saved successfully"
        @order.create_entry
      else
        render @order
      end
    end

    def show
      @order = StoreFrontModule::Order.includes(line_items: [ :line_itemable ]).find(params[:id])
      @line_items = @order.line_items
      respond_to do |format|
        format.html
        format.pdf do
          pdf = OrderPdf.new(@order, @line_items, view_context)
          send_data pdf.render, type: "application/pdf", disposition: "inline", file_name: "Invoice.pdf"
          pdf.print
        end
      end
    end

    private

    def order_params
      params.require(:store_front_module_order).permit(:customer_id, :date, :pay_type, :cash_tendered, :order_change, :total_cost, :employee_id, :cart_id)
    end
  end
end
