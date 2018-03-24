module StoreFrontModule
  module LineItems
    class PurchaseReturnLineItemProcessing
      include ActiveModel::Model
      attr_accessor :product_id,
                    :cart_id,
                    :unit_cost,
                    :total_cost,
                    :unit_of_measurement_id,
                    :employee_id,
                    :supplier_id,
                    :barcode,
                    :quantity,
                    :purchase_line_item_id
      validates :quantity, presence: true, numericality: true
      validate :quantity_is_less_than_or_equal_to_available_quantity?
      def process!
        ActiveRecord::Base.transaction do
          create_purchase_return_line_item
        end
      end

      private
      def create_purchase_return_line_item
        find_cart.purchase_return_line_items.create(
          quantity: quantity,
          unit_cost: purchase_cost,
          total_cost: set_total_cost,
          unit_of_measurement_id: unit_of_measurement_id,
          barcode: barcode,
          product: find_product,
          purchase_line_item: find_purchase_line_item)
      end

      def find_cart
        StoreFrontModule::Cart.find_by_id(cart_id)
      end

      def find_product
        StoreFrontModule::Product.find_by_id(product_id)
      end

      def purchase_cost
        find_purchase_line_item.unit_cost
      end

      def set_total_cost
        purchase_cost * quantity.to_f
      end

      def find_purchase_line_item
        StoreFrontModule::LineItems::PurchaseLineItem.find_by_id(purchase_line_item_id)
      end

      def converted_quantity
        find_unit_of_measurement.conversion_multiplier * quantity.to_f
      end

      def find_unit_of_measurement
        find_product.unit_of_measurements.find_by_id(unit_of_measurement_id)
      end

      def available_quantity
        if product_id.present? && barcode.blank?
          find_product.available_quantity
        elsif purchase_line_item_id.present? && barcode.present?
          find_purchase_line_item.available_quantity
        end
      end

      private
      def quantity_is_less_than_or_equal_to_available_quantity?
        errors[:quantity] << "exceeded available quantity" if converted_quantity.to_f > available_quantity
      end
    end
  end
end
