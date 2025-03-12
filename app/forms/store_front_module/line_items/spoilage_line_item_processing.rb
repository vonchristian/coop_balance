module StoreFrontModule
  module LineItems
    class SpoilageLineItemProcessing
      include ActiveModel::Model
      attr_accessor :unit_of_measurement_id,
                    :quantity,
                    :cart_id,
                    :product_id,
                    :unit_cost,
                    :total_cost,
                    :cart_id,
                    :barcode,
                    :purchase_line_item_id

      validates :quantity, numericality: { greater_than: 0.1 }
      validate :quantity_is_less_than_or_equal_to_available_quantity?

      def process!
        ActiveRecord::Base.transaction do
          process_spoilage
        end
      end

      private

      def process_spoilage
        find_cart.spoilage_line_items.create(
          quantity: quantity,
          unit_cost: purchase_cost,
          total_cost: set_total_cost,
          unit_of_measurement_id: unit_of_measurement_id,
          barcode: barcode,
          product: find_product,
          purchase_line_item: find_purchase_line_item
        )
      end

      def converted_quantity
        find_unit_of_measurement.conversion_multiplier * quantity.to_f
      end

      def purchase_cost
        if find_purchase_line_item.present?
          find_purchase_line_item.unit_cost
        elsif find_product.present?
          find_product.last_purchase_cost
        end
      end

      def find_cart
        StoreFrontModule::Cart.find_by(id: cart_id)
      end

      def set_total_cost
        purchase_cost * quantity.to_f
      end

      def find_unit_of_measurement
        StoreFrontModule::UnitOfMeasurement.find_by(id: unit_of_measurement_id)
      end

      def find_product
        Product.find_by(id: product_id)
      end

      def find_purchase_line_item
        StoreFrontModule::LineItems::PurchaseLineItem.find_by(id: purchase_line_item_id)
      end

      def available_quantity
        if product_id.present?
          find_product.available_quantity
        elsif referenced_line_item_id.present?
          find_purchase_order_line_item.available_quantity
        end
      end

      def quantity_is_less_than_or_equal_to_available_quantity?
        errors[:quantity] << "exceeded available quantity" if converted_quantity.to_f > available_quantity
      end
    end
  end
end
