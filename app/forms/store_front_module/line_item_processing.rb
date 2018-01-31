module StoreFrontModule
  class LineItemProcessing
    include ActiveModel::Model
    include ActiveModel::Validations
    attr_accessor :unit_of_measurement_id, :quantity, :cart_id, :product_id
    validates :quantity, numericality: { less_than_or_equal_to: :available_stock }, on: :create
    validate :quantity_is_less_than_or_equal_to_available_stock?
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

    def available_quantity
      find_product.in_stock
    end

    def converted_quantity
      find_unit_of_measurement.conversion_multiplier * quantity.to_f
    end

    def quantity_is_less_than_or_equal_to_available_stock?
      errors[:quantity] << "exceeded" if converted_quantity.to_f > available_quantity
    end

    def find_product
      StoreFrontModule::Product.find_by_id(product_id)
    end

    def applicable_num(quantity)
      1.upto(find_product.stocks.count).each do |num|
      stocks.last(num).sum(:quantity) >= quantity
        num
      end
    end
    def decrease_stocks
      if !remaining_quantity.zero?
        find_product.stocks.order(date: :asc).last(applicable_num(quantity) -1).each do |stock|
          stock.line_items.create(quantity: stock.in_stock)
        end
         find_product.stocks.order(date: :asc).last(applicable_num(quantity)).last.sold_items.create(quantity: remaining_quantity(quantity))
      else
        find_product.stocks.order(date: :asc).last(applicable_num(quantity)).each do |stock|
          stock.line_items.create(quantity: stock.in_stock)
        end
      end
    end

    def remaining_quantity(quantity)
      num = find_product.stocks.order(date: :asc).last(applicable_num(quantity)-1).sum(&:quantity) - quantity
      if num.zero?
        0
      else
        num
      end
    end
  end
end
