module StoreFrontModule
  module Orders
    class SalesController < ApplicationController
      def index
        if params[:search].present?
          @sales_orders = StoreFrontModule::Orders::SalesOrder.
          includes(:commercial_document, :sales_line_items, :line_items, :employee).
          text_search(params[:search]).
          order(date: :desc).
          paginate(page: params[:page], per_page: 30)
        else
          @sales_orders = StoreFrontModule::Orders::SalesOrder.
          includes(:commercial_document, :sales_line_items, :line_items, :employee).
          order(date: :desc).
          paginate(page: params[:page], per_page: 30)
        end
        @from_date = Chronic.parse(params[:from_date])
        @to_date = Chronic.parse(params[:to_date])
        respond_to do |format|
          format.html
          format.pdf do
            pdf = StoreFrontModule::Reports::SalesReportPdf.new(@sales_orders, @from_date, @to_date, view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Sales Order.pdf"
          end
        end
      end
      def show
        @sales_order = current_cooperative.sales.find(params[:id])
        @customer = @sales_order.commercial_document
        respond_to do |format|
          format.html
          format.pdf do
            pdf = StoreFrontModule::Orders::SalesOrderPdf.new(@sales_order, @customer, view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Sales Order.pdf"
          end
        end
      end
      def create
        @cart = current_cart
        @sales_order = StoreFrontModule::Orders::SalesOrderProcessing.new(order_processing_params)
        if @sales_order.valid?
          @sales_order.process!
          redirect_to new_store_front_module_sales_line_item_url, notice: "Order processed successfully."
        else
          render :new
        end
      end

      private
      def order_processing_params
        params.require(:store_front_module_orders_sales_order_processing).
        permit(:cash_account_id, :customer_id, :date, :cash_tendered, :order_change, :total_cost, :employee_id, :cart_id, :discount_amount)
      end
    end
  end
end
