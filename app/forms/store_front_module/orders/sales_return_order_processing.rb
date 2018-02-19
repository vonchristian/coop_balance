module StoreFrontModule
  module Orders
    class SalesReturnOrderProcessing
      include ActiveModel::Model
      attr_accessor  :cart_id, :customer_id, :employee_id, :date, :note
      validates :customer_id, presence: true
      # validate :amount_is_greater_than_or_equal_to_cash_on_hand?
      def process!
        ActiveRecord::Base.transaction do
          create_sales_return_order
        end
      end

      private

      def create_sales_return_order
        order = find_customer.sales_return_orders.create(date: date, employee_id: employee_id)
        find_cart.sales_return_order_line_items.each do |line_item|
          line_item.cart_id = nil
          order.sales_return_order_line_items << line_item
        end
        create_entry(order)
        order.create_note(content: note, noter: find_employee)
      end

      def find_customer
        return User.find_by_id(customer_id) if User.find_by_id(customer_id).present?
        return Member.find_by_id(customer_id)
      end

      def find_cart
        Cart.find_by_id(cart_id)
      end
      def find_employee
        User.find_by_id(employee_id)
      end
      def create_entry(order)
        cash_on_hand = find_employee.cash_on_hand_account
        sales_return = CoopConfigurationsModule::StoreFrontConfig.default_sales_return_account
        merchandise_inventory = CoopConfigurationsModule::StoreFrontConfig.default_merchandise_inventory_account
        cost_of_goods_sold = CoopConfigurationsModule::StoreFrontConfig.default_cost_of_goods_sold_account
        find_employee.entries.create(
          commercial_document: find_customer,
          entry_date: order.date,
          description: "Payment for sales",
          debit_amounts_attributes: [{ amount: order.total_cost,
                                        account: sales_return,
                                        commercial_document: order},
                                      { amount: order.total_cost,
                                        account: merchandise_inventory,
                                        commercial_document: order } ],
            credit_amounts_attributes:[{amount: order.total_cost,
                                        account: cash_on_hand,
                                        commercial_document: order},
                                       {amount: order.total_cost,
                                        account: cost_of_goods_sold,
                                        commercial_document: order}])
      end
      def amount_is_greather_than_or_equal_to_cash_on_hand?
        errors[:quantity] << "exceeded sold quantity" if amount.to_f > find_employee.cash_on_hand_account_balance
      end

    end
  end
end
