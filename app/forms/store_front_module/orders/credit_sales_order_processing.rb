module StoreFrontModule
  module Orders
    class CreditSalesOrderProcessing
      include ActiveModel::Model
      attr_accessor  :customer_id, :employee_id, :cart_id, :date, :description, :reference_number

      validates :employee_id, :customer_id, :description, :reference_number, presence: true

      def process!
        if valid?
          ActiveRecord::Base.transaction do
            create_sales_order
          end
        end
      end

      private
      def create_sales_order
        order = find_customer.sales_orders.create(
        credit: true,
        cooperative: find_employee.cooperative,
        store_front: find_employee.store_front,
        date: date,
        reference_number: reference_number,
        description: "Credit sales #{find_customer.name}",
        employee: find_employee)

        find_cart.sales_line_items.each do |sales_line_item|
          sales_line_item.cart_id = nil
          order.sales_line_items << sales_line_item
        end
        create_voucher(order)
        create_entry(order)
      end

      def create_voucher(order)
        StoreFrontModule::Vouchers::CreditSalesOrder.new(order: order).create_voucher!
      end

      def create_entry(order)
        StoreFrontModule::Vouchers::EntryProcessing.new(voucher: order.voucher).create_entry!
      end

      def find_customer
        Customer.find(customer_id)
      end

      def find_cart
        Cart.find(cart_id)
      end

      def find_employee
        User.find(employee_id)
      end
    end
  end
end
