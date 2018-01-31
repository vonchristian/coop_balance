module StoreFrontModule
  class ProductRegistration
    include ActiveModel::Model
    attr_accessor :category_id,
                  :name,
                  :description,
                  :unit_of_measurement_code,
                  :unit_of_measurement_description,
                  :quantity,
                  :price
    def register!
      ActiveRecord::Base.transaction do
        create_product
      end
    end

    private
    def create_product
      product = StoreFrontModule::Product.find_or_create_by(
        name: name,
        description: description
         )
      StoreFrontModule::UnitOfMeasurement.create(
        product: product,
        code: unit_of_measurement_code,
        description: unit_of_measurement_description,
        quantity: quantity,
        price: price,
        base_measurement: true
        )
    end
  end
end
