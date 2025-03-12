module StoreFrontModule
  class MarkUpPricesController < ApplicationController
    def new
      @unit_of_measurement = StoreFrontModule::UnitOfMeasurement.find(params[:unit_of_measurement_id])
      @mark_up_price = @unit_of_measurement.mark_up_prices.build
    end

    def create
      @unit_of_measurement = StoreFrontModule::UnitOfMeasurement.find(params[:unit_of_measurement_id])
      @mark_up_price = @unit_of_measurement.mark_up_prices.create(mark_up_price_params)
      if @mark_up_price.valid?
        @mark_up_price.save
        redirect_to store_front_module_product_url(@unit_of_measurement.product), notice: "Mark up price updated successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def mark_up_price_params
      params.require(:store_front_module_mark_up_price).permit(:price, :date)
    end
  end
end
