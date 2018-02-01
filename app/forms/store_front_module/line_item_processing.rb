module StoreFrontModule
  class LineItemProcessing
    include ActiveModel::Model
    include ActiveModel::Validations
    attr_accessor :unit_of_measurement_id, :quantity, :cart_id, :product_id
    validates :quantity, numericality: { less_than_or_equal_to: :available_stock }, on: :create
    def process!
      ActiveRecord::Base.transaction do
          create_line_item
      end
    end

    private
    def create_line_item
      find_cart.sales_line_items.create(product_id: product_id,
                                  quantity: quantity,
                                  unit_cost: find_unit_of_measurement.price,
                                  total_cost: find_unit_of_measurement.price * quantity.to_f,
                                  unit_of_measurement_id: unit_of_measurement_id)
    end

    def find_cart
      StoreFrontModule::Cart.find_by_id(cart_id)
    end
    def find_unit_of_measurement
      UnitOfMeasurement.find_by_id(unit_of_measurement_id)
    end
    def find_stock
      StoreFrontModule::ProductStock.find_by_id(line_itemable_id)
    end

    def available_quantity
      find_product.balance
    end

    def converted_quantity
      find_unit_of_measurement.conversion_multiplier * quantity.to_f
    end

    def find_product
      StoreFrontModule::Product.find_by_id(product_id)
    end
  end
end
