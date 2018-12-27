module StoreFrontModule
  module Settings
    class StockRegistriesController < ApplicationController
      def create
        @registry = StoreFrontModule::StockRegistryProcessing.new(registry_params)
        if @registry.valid?
          @registry.process!
          redirect_to store_front_module_voucher_url(@registry.find_voucher), notice: "Products uploaded successfully."
          @registry.parse_for_records
        else
          render :new
        end
      end

      private
      def registry_params
        params.require(:registries_stock_registry).
        permit(:spreadsheet, :employee_id, :date, :voucher_account_number, :store_front_id)
      end
    end
  end
end
