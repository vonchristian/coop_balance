module Suppliers
  class DeliveryProcessingsController < ApplicationController
    def create
      @supplier = Supplier.find(params[:supplier_id])
      @delivery_processing = Suppliers::DeliveryProcessing.new(delivery_processing_params)
      if @delivery_processing.valid?
        @delivery_processing.process!
        redirect_to supplier_deliveries_url(@supplier), notice: "Stocks saved successfully."
      else
        redirect_to new_supplier_delivery_url(@supplier), alert: "Error applying voucher"
      end
    end

    private
    def delivery_processing_params
      params.require(:suppliers_delivery_processing).permit(:voucher_id, :registry_id, :supplier_id, :payable_amount)
    end
  end
end
