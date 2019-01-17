module StoreFrontModule
  module LineItems
    class SalesLineItemProcessing
     include ActiveModel::Model
      attr_accessor :unit_of_measurement_id,
                    :quantity,
                    :cart_id,
                    :product_id,
                    :unit_cost,
                    :total_cost,
                    :cart_id,
                    :barcode,
                    :employee_id,
                    :store_front_id,
                    :purchase_line_item_id

      validates :quantity, numericality: { greater_than: 0.1 }
      validate :ensure_quantity_is_less_than_or_equal_to_available_quantity?

      def process!
        ActiveRecord::Base.transaction do
          process_sales_line_item
        end
      end

      private
      def process_sales_line_item
        if product_id.present? && barcode.blank?
          create_product_sales
        elsif purchase_line_item_id.present? && barcode.present?
            create_purchase_line_item_sales
        end
      end

       def create_product_sales
        sales_line_item = find_cart.sales_line_items.create!(
            quantity:            quantity,
            unit_cost:           selling_cost,
            total_cost:          set_total_cost,
            unit_of_measurement: find_unit_of_measurement,
            product:             find_product)
        sales_line_item.barcodes.create!(code: barcode)
        requested_quantity = converted_quantity

        find_product.purchases.order(created_at: :asc).available.each do |purchase|
          temp_sales = sales_line_item.sales_purchase_line_items.create!(
            quantity:                 quantity_for(purchase, requested_quantity),
            unit_cost:                purchase.purchase_cost,
            total_cost:               total_cost_for(purchase, quantity),
            unit_of_measurement:      find_product.base_measurement,
            product_id:               product_id,
            purchase_line_item:       purchase,
            sales_line_item:          sales_line_item)
          requested_quantity -= temp_sales.quantity
          break if requested_quantity.zero?
        end
      end

      def create_purchase_line_item_sales
        sales_line_item = find_cart.sales_line_items.create!(
          quantity:            quantity,
          unit_cost:           selling_cost,
          total_cost:          set_total_cost,
          product_id:          product_id,
          unit_of_measurement: find_unit_of_measurement
          )
        sales_line_item.barcodes.create(code: barcode)

        purchase = find_purchase_line_item
        sales_line_item.sales_purchase_line_items.create!(
            quantity:            converted_quantity,
            unit_cost:           purchase.purchase_cost,
            total_cost:          total_cost_for(purchase, quantity),
            unit_of_measurement: find_product.base_measurement,
            product_id:          product_id,
            purchase_line_item:  purchase,
            sales_line_item:     sales_line_item)
      end

      def quantity_for(purchase, requested_quantity)
        if purchase.available_quantity(store_front: find_store_front) >= BigDecimal(requested_quantity)
          BigDecimal(requested_quantity)
        else
          purchase.available_quantity(store_front: find_store_front).to_f
        end
      end

      def converted_quantity
        find_unit_of_measurement.conversion_multiplier * quantity.to_f
      end
      def find_cart
        StoreFrontModule::Cart.find(cart_id)
      end

      def selling_cost
        if unit_cost.present?
          unit_cost.to_f
        else
          find_unit_of_measurement.price
        end
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
        Product.find(product_id)
      end

      def find_store_front
        find_employee.store_front
      end

      def find_employee
        User.find(employee_id)
      end

      def find_purchase_line_item
        StoreFrontModule::LineItems::PurchaseLineItem.find_by(id: purchase_line_item_id)
      end

      def available_quantity
        if product_id.present? && barcode.blank?
          find_product.balance(store_front: find_store_front)
        elsif purchase_line_item_id.present? && barcode.present?
          find_purchase_line_item.available_quantity(store_front: find_store_front)
        end
      end

      def ensure_quantity_is_less_than_or_equal_to_available_quantity?
        errors[:quantity] << "exceeded available quantity" if converted_quantity.to_f > available_quantity
      end
    end
  end
end
