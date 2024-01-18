module StoreFrontModule
  class ProductRegistration
    include ActiveModel::Model
    attr_accessor :category_id,
                  :name,
                  :description,
                  :unit_of_measurement_code,
                  :unit_of_measurement_description,
                  :base_quantity,
                  :price,
                  :cooperative_id

    validates :name, :unit_of_measurement_code, :base_quantity, :price, presence: true
    validates :base_quantity, :price, numericality: true
    def register!
      ActiveRecord::Base.transaction do
        create_product
      end
    end

    private

    def create_product
      product = StoreFrontModule::Product.find_or_create_by(
        name: name,
        cooperative: find_cooperative,
        description: description
      )
      unit_of_measurement = StoreFrontModule::UnitOfMeasurement.create(
        product: product,
        code: unit_of_measurement_code,
        description: unit_of_measurement_description,
        base_quantity: base_quantity,
        base_measurement: true
      )
      unit_of_measurement.mark_up_prices.create(price: price)
    end

    def find_cooperative
      Cooperative.find(cooperative_id)
    end
  end
end
