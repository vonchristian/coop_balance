module StoreFrontModule
  module LineItems
    class SalesReturnOrderLineItemProcessing
     include ActiveModel::Model
      attr_accessor :commercial_document_id, :commercial_document_type, :unit_of_measurement_id, :quantity, :cart_id, :product_id, :unit_cost, :total_cost, :cart_id, :barcode, :referenced_line_item_id

      def process!
        ActiveRecord::Base.transaction do
          process_sales_return
        end
      end

      private
      def process_sales_return
        if product_id.present?
          update_product_available_quantity
        end
      end
      def update_product_available_quantity
        sales_return = find_cart.sales_return_order_line_items.create!(quantity: quantity,
                                                   unit_cost: selling_cost,
                                                   total_cost: selling_cost * quantity.to_f,
                                                   unit_of_measurement: find_unit_of_measurement,
                                                   product_id: product_id
                                                  )
      end
      def find_product
        StoreFrontModule::Product.find_by_id(product_id)
      end

      def find_unit_of_measurement
        StoreFrontModule::UnitOfMeasurement.find_by_id(unit_of_measurement_id)
      end

      def find_cart
        StoreFrontModule::Cart.find_by_id(cart_id)
      end
      def selling_cost
        find_unit_of_measurement.price
      end
      def find_customer
        return User.find_by_id(customer_id) if User.find_by_id(customer_id).present?
        return Member.find_by_id(customer_id)
      end
    end
  end
end
