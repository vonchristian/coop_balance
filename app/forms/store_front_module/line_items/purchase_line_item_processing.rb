module StoreFrontModule
  module LineItems
    class PurchaseLineItemProcessing
     include ActiveModel::Model
      attr_accessor :unit_of_measurement_id, :quantity, :cart_id, :product_id, :unit_cost, :total_cost, :cart_id, :barcode

      def process!
        ActiveRecord::Base.transaction do
          process_line_item
        end
      end

      private
      def process_line_item
        line_item = find_cart.purchase_order_line_items.create(
                                    quantity: quantity,
                                    unit_cost: unit_cost,
                                    total_cost: total_cost,
                                    unit_of_measurement_id: unit_of_measurement_id,
                                    product_id: product_id,
                                    barcode: barcode
                                    )
      end

      def find_cart
        StoreFrontModule::Cart.find_by_id(cart_id)
      end
    end
  end
end
