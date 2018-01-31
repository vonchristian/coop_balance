module StoreFrontModule
  class LineItemProcessing
    include ActiveModel::Model
    include ActiveModel::Validations
    attr_accessor :unit_of_measurement_id, :quantity, :cart_id, :line_itemable_id, :line_itemable_type, :search
    validates :quantity, numericality: { less_than_or_equal_to: :stock_quantity }, on: :create
    validate :quantity_is_less_than_or_equal_to_available_stock_quantity?
    def process!
      ActiveRecord::Base.transaction do
          create_line_item
      end
    end

    private
    def create_line_item
      find_cart.line_items.create(line_itemable_id: line_itemable_id,
                                  line_itemable_type: line_itemable_type,
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
    def stock_quantity
      find_stock.in_stock
    end

    def converted_quantity
      if find_unit_of_measurement.base_measurement?
        quantity.to_f
      else
        quantity.to_f * find_unit_of_measurement.conversion_quantity.to_f
      end
    end

    def quantity_is_less_than_or_equal_to_available_stock_quantity?
      errors[:quantity] << "exceeded" if converted_quantity.to_f > stock_quantity
    end
  end
end
