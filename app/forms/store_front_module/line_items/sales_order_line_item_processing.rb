module StoreFrontModule
  module LineItems
    class SalesOrderLineItemProcessing
     include ActiveModel::Model
      attr_accessor :unit_of_measurement_id, :quantity, :cart_id, :product_id, :unit_cost, :total_cost, :cart_id, :barcode, :referenced_line_item_id

      def process!
        ActiveRecord::Base.transaction do
          process_purchase
        end
      end

      private
      def process_purchase
        line_item = find_cart.sales_order_line_items.create(
                                    quantity: quantity,
                                    unit_cost: set_unit_cost,
                                    total_cost: set_total_cost,
                                    unit_of_measurement_id: unit_of_measurement_id,
                                    product_id: product_id,
                                    barcode: barcode,
                                    referenced_line_item_id: referenced_line_item_id)
      end

      def find_cart
        StoreFrontModule::Cart.find_by_id(cart_id)
      end
      def set_unit_cost
        find_unit_of_measurement.price
      end
      def set_total_cost
        set_unit_cost * quantity.to_f
      end
      def find_unit_of_measurement
        StoreFrontModule::UnitOfMeasurement.find_by_id(unit_of_measurement_id)
      end
    end
  end
end
