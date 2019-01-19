 module StoreFrontModule
  module Orders
    class SalesOrderProcessing
      include ActiveModel::Model
      attr_accessor  :customer_id,
                     :date,
                     :cash_tendered,
                     :order_change,
                     :employee_id,
                     :cart_id,
                     :discount_amount,
                     :total_cost,
                     :reference_number,
                     :cash_account_id

      validates :employee_id, :customer_id, :cash_tendered, :order_change, presence: true

      def process!
        ActiveRecord::Base.transaction do
          create_sales_order
        end
      end

      private
      def create_sales_order
        order = StoreFrontModule::Orders::SalesOrder.create!(
        cooperative: find_cooperative,
        commercial_document: find_customer,
        cash_tendered: cash_tendered,
        order_change: order_change,
        date: date,
        store_front: find_employee.store_front,
        employee: find_employee)

        find_cart.sales_line_items.each do |line_item|
          line_item.cart_id = nil
          order.sales_line_items << line_item
        end
        create_voucher(order)
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

      def create_voucher(order)
        StoreFrontModule::Vouchers::SalesOrder.new(order: order).create_voucher!
      end

      def total_cost_less_discount(order)
        order.total_cost - discount_amount.to_f
      end
      def find_cash_account
        find_employee.cash_accounts.find(cash_account_id)
      end
      def find_cooperative
        find_employee.cooperative
      end
    end
  end
end
