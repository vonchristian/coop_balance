module StoreFrontModule
  class UnitOfMeasurementsController < ApplicationController
    def new
      @product = StoreFrontModule::Product.find(params[:product_id])
      @unit_of_measurement = StoreFrontModule::UnitOfMeasurementRegistration.new
    end

    def create
      @product = StoreFrontModule::Product.find(params[:product_id])
      @unit_of_measurement = StoreFrontModule::UnitOfMeasurementRegistration.new(unit_of_measurement_params)
      if @unit_of_measurement.valid?
        @unit_of_measurement.register!
        redirect_to store_front_module_product_url(@product), notice: 'Unit of Measurement added successfully'
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def unit_of_measurement_params
      params.require(:store_front_module_unit_of_measurement_registration).permit(:code, :description, :quantity, :price, :base_measurement, :conversion_quantity, :product_id)
    end
  end
end
