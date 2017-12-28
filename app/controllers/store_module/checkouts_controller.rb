module StoreModule
  class CheckoutsController < ApplicationController
    def create
      @checkout = StoreFrontModule::CheckoutForm.new(checkout_params)
      if @checkout.valid?
        redirect_to new_store_front_module_order_processing_path(customer_id: @checkout.customer_id), notice: "Processing order..."
      else
        redirect_to store_index_url, alert: "Customer not found!"
      end
    end

    private
    def checkout_params
      params.require(:store_front_module_checkout_form).permit(:customer_id)
    end
  end
end
