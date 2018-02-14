module StoreFrontModule
  class UnitOfMeasurementRegistration
    include ActiveModel::Model
    attr_accessor :code, :description, :quantity, :price, :base_measurement, :conversion_quantity, :product_id

    def register!
      ActiveRecord::Base.transaction do
        create_unit_of_measurement
      end
    end
    private
    def create_unit_of_measurement
      unit_of_measurement = find_product.unit_of_measurements.create(
        code: code,
        description: description,
        quantity: quantity,
        base_measurement: base_measurement,
        conversion_quantity: conversion_quantity
        )
      unit_of_measurement.mark_up_prices.create(price: price)
    end
    def find_product
      StoreFrontModule::Product.find_by_id(product_id)
    end
  end
end
