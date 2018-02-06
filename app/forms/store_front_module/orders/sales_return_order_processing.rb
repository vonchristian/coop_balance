module StoreFrontModule
  module Orders
    class SalesReturnOrderProcessing
      include ActiveModel::Model
      attr_accessor  :cart_id, :customer_id, :commercial_document_type, :employee_id, :date, :title, :content
      validates :customer_id, presence: true

      def process!
        ActiveRecord::Base.transaction do
          create_sales_return_order
        end
      end

      private
      def create_sales_return_order
        order = find_customer.sales_return_orders.create(date: date, employee_id: employee_id)
        find_cart.purchase_order_line_items.each do |line_item|
          line_item.cart_id = nil
          order.purchase_order_line_items << line_item
        end
      end

      def find_customer
        return User.find_by_id(customer_id) if User.find_by_id(customer_id).present?
        return Member.find_by_id(customer_id)
      end

      def find_cart
        Cart.find_by_id(cart_id)
      end
    end
  end
end
