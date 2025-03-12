module StoreFrontModule
  module Settings
    class StockRegistriesController < ApplicationController
      def create
        @registry = Registries::StockRegistry.create(registry_params)
        if @registry.valid?
          @registry.save!
          @registry.parse_for_records
          redirect_to store_front_module_stock_registry_url(@registry), notice: "Products uploaded successfully."

        else
          render :new, status: :unprocessable_entity
        end
      end

      def show
        @registry = current_cooperative.stock_registries.find(params[:id])
        @registry_processing = StoreFrontModule::StockRegistryProcessing.new
      end

      private

      def registry_params
        params.require(:registries_stock_registry)
              .permit(:spreadsheet, :employee_id, :date, :store_front_id, :cooperative_id)
      end
    end
  end
end
