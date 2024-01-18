module StoreFrontModule
  module Orders
    class SalesReturnOrderProcessing
      include ActiveModel::Model
      attr_accessor :cart_id, :customer_id, :employee_id, :date, :note

      validates :customer_id, presence: true

      def process!
        ActiveRecord::Base.transaction do
          create_sales_return_order
        end
      end

      private

      def create_sales_return_order
        order = find_customer.sales_return_orders.create(
          date: date,
          employee_id: employee_id
        )
        find_cart.sales_return_line_items.each do |line_item|
          line_item.cart_id = nil
          order.sales_return_line_items << line_item
        end
        create_entry(order)
        order.create_note(content: note, noter: find_employee)
      end

      def find_customer
        Customer.find_by(id: customer_id)
      end

      def find_cart
        Cart.find_by(id: cart_id)
      end

      def find_employee
        User.find_by(id: employee_id)
      end

      def create_entry(order)
        store_front = find_employee.store_front
        cash_on_hand = find_employee.cash_on_hand_account
        sales_return = store_front.sales_return_account
        merchandise_inventory = store_front.merchandise_inventory_account
        cost_of_goods_sold = store_front.cost_of_goods_sold_account
        find_employee.entries.create(
          commercial_document: find_customer,
          origin: find_employee.office,
          entry_date: order.date,
          description: note,
          debit_amounts_attributes: [{ amount: order.total_cost,
                                       account: sales_return,
                                       commercial_document: order },
                                     { amount: order.total_cost,
                                       account: merchandise_inventory,
                                       commercial_document: order }],
          credit_amounts_attributes: [{ amount: order.total_cost,
                                        account: cash_on_hand,
                                        commercial_document: order },
                                      { amount: order.total_cost,
                                        account: cost_of_goods_sold,
                                        commercial_document: order }]
        )
      end
    end
  end
end
