module StoreFrontModule
  class StockRegistryProcessingsController < ApplicationController
    def create
      @registry = current_cooperative.stock_registries.find(params[:store_front_module_stock_registry_processing][:registry_id])
      @registry_processing = StoreFrontModule::StockRegistryProcessing.new(registry_params)
      if @registry_processing.valid?
        @registry_processing.process!
        redirect_to "/", notice: "Uploaded successfully."
      else
        redirect_to store_front_module_stock_registry_url(@stock_registry), alert: "Error uploading"
      end
    end

    private
    def registry_params
      params.require(:store_front_module_stock_registry_processing).
      permit(:date, :reference_number, :description, :registry_id, :employee_id)
    end
  end
end
