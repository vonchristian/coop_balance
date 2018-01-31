module StoreFrontModule
  class UnitOfMeasurementsController < ApplicationController
    def new
      @product = StoreFrontModule::Product.find(params[:product_id])
      @unit_of_measurement = @product.unit_of_measurements.build
    end

    def create
      @product = StoreFrontModule::Product.find(params[:product_id])
      @unit_of_measurement = @product.unit_of_measurements.create(unit_of_measurement_params)
      if @unit_of_measurement.valid?
        @unit_of_measurement.save
        redirect_to store_front_module_product_url(@product), notice: "Unit of Measurement added successfully"
      else
        render :new
      end
    end

    private
    def unit_of_measurement_params
      params.require(:unit_of_measurement).permit(:code, :description, :quantity, :price, :base_measurement, :conversion_quantity)
    end
  end
end
