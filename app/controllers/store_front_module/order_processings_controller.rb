module StoreFrontModule
  class OrderProcessingsController < ApplicationController
    def new
      @order = StoreFrontModule::OrderProcessingForm.new
       @cart = current_cart
      @customer = StoreFrontModule::CheckoutForm.new.find_customer(params[:customer_id])
    end
    def create
      @cart = current_cart
      @order = StoreFrontModule::OrderProcessingForm.new(order_processing_params)
      if @order.valid?
        @order.save
        redirect_to store_index_url, notice: "Order processed successfully."
      else
        render :new
      end
    end

    private
    def order_processing_params
      params.require(:store_front_module_order_processing_form).permit(:customer_id, :customer_type, :date, :pay_type, :cash_tendered, :order_change, :total_cost, :employee_id, :cart_id, :date)
    end
  end
end
