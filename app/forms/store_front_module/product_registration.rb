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
    validates :name, :unit_of_measurement_code, :quantity, :price, presence: true
    validates :quantity, :price, numericality: true
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
      unit_of_measurement = StoreFrontModule::UnitOfMeasurement.create(
        product: product,
        code: unit_of_measurement_code,
        description: unit_of_measurement_description,
        quantity: quantity,
        base_measurement: true
        )
      unit_of_measurement.mark_up_prices.create(price: price)
    end
  end
end
