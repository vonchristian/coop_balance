module StoreFrontModule
  module LineItems
    class PurchaseReturnOrderLineItemProcessing
      include ActiveModel::Model
      attr_accessor :product_id, :cart_id, :unit_cost, :total_cost,  :unit_of_measurement_id, :employee_id, :supplier_id, :barcode, :quantity
      def process!
        ActiveRecord::Base.transaction do
          create_purchase_return_line_item
        end
      end

      private
      def create_purchase_return_line_item
        find_cart.purchase_return_order_line_items.create(
          quantity: quantity,
          unit_cost: unit_cost,
          total_cost: total_cost,
          unit_of_measurement_id: unit_of_measurement_id,
          barcode: barcode,
          product: find_product)
      end
      def find_cart
        StoreFrontModule::Cart.find_by_id(cart_id)
      end

      def find_product
        StoreFrontModule::Product.find_by_id(product_id)
      end
    end
  end
end
