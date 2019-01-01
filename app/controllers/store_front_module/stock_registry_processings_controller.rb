module StoreFrontModule
  class StockRegistryProcessingsController < ApplicationController
    def create
      @registry_processing = StoreFrontModule::StockRegistryProcessing.new(registry_params)
      if @registry_processing.valid?
        @registry_processing.process!
      end
    end

    private
    def registry_params
      params.require(:store_front_module_stock_registry_processing).
      permit(:date, :reference_number, :description, :registry_id, :employee_id)
    end
  end
end
