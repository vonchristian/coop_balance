module StoreFrontModule
  module LineItems
    class SalesReturnOrderLineItemProcessing
     include ActiveModel::Model
      attr_accessor :unit_of_measurement_id, :quantity, :cart_id, :product_id, :unit_cost, :total_cost, :cart_id, :barcode, :referenced_line_item_id
      validate :quantity_is_less_than_or_equal_to_sold_quantity?
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

      def find_employee
        User.find_by_id(employee_id)
      end
     def sold_quantity
        if product_id.present? && barcode.blank?
          find_product.sales_balance
        elsif referenced_line_item_id.present? && barcode.present?
          find_purchase_order_line_item.sold_quantity
        end
      end

      def find_product
        StoreFrontModule::Product.find_by_id(product_id)
      end

      # def create_entry(sales_return_order)
      #   cash_on_hand = find_employee.cash_on_hand_account
      #   sales_return_account = AccountingModule::Account.find_by(name: "Sales Returns and Allowances")
      #   merchandise_inventory = CoopConfigurationsModule::StoreFrontConfig.default_merchandise_inventory_account
      #   find_employee.entries.create!(
      #     commercial_document: sales_return_order,
      #     entry_date: sales_return_order.date,
      #     description: "Sales Return",
      #     debit_amounts_attributes: [amount: sales_return_order.total_cost,
      #                               account: sales_return_account,
      #                               commercial_document: sales_return_order ],
      #     credit_amounts_attributes:[account: merchandise_inventory,
      #                                amount: sales_return_order.total_cost,
      #                                commercial_document: sales_return_order])
      # end
      def converted_quantity
        find_unit_of_measurement.conversion_multiplier * quantity.to_f
      end
      def quantity_is_less_than_or_equal_to_sold_quantity?
        errors[:quantity] << "exceeded sold quantity" if converted_quantity.to_f > sold_quantity
      end
    end
  end
end
