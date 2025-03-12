module StoreFrontModule
  module LineItems
    class SalesReturnLineItemProcessing
      include ActiveModel::Model
      attr_accessor :unit_of_measurement_id,
                    :quantity,
                    :cart_id,
                    :product_id,
                    :unit_cost,
                    :total_cost,
                    :barcode,
                    :purchase_line_item_id

      validates :product_id,
                :unit_of_measurement_id,
                presence: true
      validate :quantity_is_less_than_or_equal_to_sold_quantity?
      def process!
        ActiveRecord::Base.transaction do
          process_sales_return
        end
      end

      private

      def process_sales_return
        create_sales_return
      end

      def create_sales_return
        find_cart.sales_return_line_items.create!(
          quantity: quantity,
          unit_cost: selling_cost,
          total_cost: set_total_cost,
          unit_of_measurement: find_unit_of_measurement,
          product_id: product_id,
          purchase_line_item_id: purchase_line_item_id
        )
      end

      def find_product
        StoreFrontModule::Product.find_by(id: product_id)
      end

      def find_unit_of_measurement
        StoreFrontModule::UnitOfMeasurement.find_by(id: unit_of_measurement_id)
      end

      def find_cart
        StoreFrontModule::Cart.find_by(id: cart_id)
      end

      def selling_cost
        find_unit_of_measurement.price
      end

      def set_total_cost
        selling_cost * quantity.to_f
      end

      def find_customer
        Customer.find_by(id: customer_id)
      end

      def find_employee
        User.find_by(id: employee_id)
      end

      def sold_quantity
        if product_id.present? && barcode.blank?
          find_product.sales_balance
        elsif purchase_line_item_id.present? && barcode.present?
          find_purchase_line_item.sold_quantity
        end
      end

      def find_product
        StoreFrontModule::Product.find_by(id: product_id)
      end

      def find_purchase_line_item
        StoreFrontModule::LineItems::PurchaseLineItem.find_by(id: purchase_line_item_id)
      end

      def converted_quantity
        find_unit_of_measurement.conversion_multiplier * quantity.to_f
      end

      def quantity_is_less_than_or_equal_to_sold_quantity?
        errors[:quantity] << "exceeded sold quantity" if converted_quantity.to_f > sold_quantity
      end
    end
  end
end
