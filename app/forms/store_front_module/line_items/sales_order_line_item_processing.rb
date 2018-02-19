module StoreFrontModule
  module LineItems
    class SalesOrderLineItemProcessing
     include ActiveModel::Model
      attr_accessor :unit_of_measurement_id, :quantity, :cart_id, :product_id, :unit_cost, :total_cost, :cart_id, :barcode, :purchase_order_line_item_id, :barcode
      validates :quantity, numericality: { greater_than: 0.1 }
      validate :quantity_is_less_than_or_equal_to_available_quantity?
      def process!
        ActiveRecord::Base.transaction do
          process_sales_order_line_item
        end
      end

      private
      def process_sales_order_line_item
        if product_id.present? && barcode.blank?
          decrease_product_available_quantity
        elsif purchase_order_line_item_id.present? && barcode.present?
            decrease_purchase_line_item_quantity
        end
      end

       def decrease_product_available_quantity
        sales = find_cart.sales_order_line_items.create!(
            quantity: quantity,
            unit_cost:                selling_cost,
            total_cost:               set_total_cost,
            unit_of_measurement:      find_unit_of_measurement,
            product_id:               product_id)

        requested_quantity = converted_quantity

        find_product.purchases.order(date: :asc).available.each do |purchase|
          temp_sales = sales.referenced_purchase_order_line_items.create!(
            quantity:                 quantity_for(purchase, requested_quantity),
            unit_cost:                purchase.purchase_cost,
            total_cost:               total_cost_for(purchase, quantity),
            unit_of_measurement:      find_product.base_measurement,
            product_id:               product_id,
            purchase_order_line_item: purchase)
          requested_quantity -= temp_sales.quantity
          break if requested_quantity.zero?
        end
      end

      def decrease_purchase_line_item_quantity
        sales = find_cart.sales_order_line_items.create!(
          quantity: quantity,
          unit_cost: selling_cost,
          total_cost: set_total_cost,
          product_id: product_id,
          unit_of_measurement: find_unit_of_measurement
          )
        purchase = find_purchase_order_line_item
        sales = sales.referenced_purchase_order_line_items.create!(
            quantity:                 converted_quantity,
            unit_cost:                purchase.purchase_cost,
            total_cost:               total_cost_for(purchase, quantity),
            unit_of_measurement:      find_product.base_measurement,
            product_id:               product_id,
            purchase_order_line_item: purchase)
      end

      def quantity_for(purchase, requested_quantity)
        if purchase.available_quantity >= BigDecimal.new(requested_quantity)
          BigDecimal.new(requested_quantity)
        else
          purchase.available_quantity.to_f
        end
      end

      def converted_quantity
        find_unit_of_measurement.conversion_multiplier * quantity.to_f
      end
      def find_cart
        StoreFrontModule::Cart.find_by_id(cart_id)
      end

      def selling_cost
        find_unit_of_measurement.price
      end

      def set_total_cost
        selling_cost * quantity.to_f
      end

      def total_cost_for(purchase, requested_quantity)
        purchase.purchase_cost * quantity_for(purchase, requested_quantity)
      end

      def find_unit_of_measurement
        find_product.unit_of_measurements.find_by_id(unit_of_measurement_id)
      end

      def find_product
        Product.find_by_id(product_id)
      end

      def find_purchase_order_line_item
        StoreFrontModule::LineItems::PurchaseOrderLineItem.find_by_id(purchase_order_line_item_id)
      end

      def available_quantity
        if product_id.present? && barcode.blank?
          find_product.available_quantity
        elsif purchase_order_line_item_id.present? && barcode.present?
          find_purchase_order_line_item.available_quantity
        end
      end

      def quantity_is_less_than_or_equal_to_available_quantity?
        errors[:quantity] << "exceeded available quantity" if converted_quantity.to_f > available_quantity
      end
    end
  end
end
