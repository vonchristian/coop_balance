module StoreFrontModule
  module Orders
    class CreditSalesOrderProcessing
      include ActiveModel::Model
      attr_accessor  :customer_id,  :employee_id, :cart_id, :date

      validates :employee_id, :customer_id, presence: true
      def process!
        ActiveRecord::Base.transaction do
          create_sales_order
        end
      end

      private
      def create_sales_order
        order = find_customer.sales_orders.create(
        date: date,
        employee: find_employee)

        find_cart.sales_order_line_items.each do |sales_order_line_item|
          sales_order_line_item.cart_id = nil
          order.sales_order_line_items << sales_order_line_item
        end
        create_entry(order)
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
        accounts_receivable = CoopConfigurationsModule::StoreFrontConfig.default_accounts_receivable_account
        cash_on_hand = find_employee.cash_on_hand_account
        cost_of_goods_sold = CoopConfigurationsModule::StoreFrontConfig.default_cost_of_goods_sold_account
        sales = CoopConfigurationsModule::StoreFrontConfig.default_sales_account
        merchandise_inventory = CoopConfigurationsModule::StoreFrontConfig.default_merchandise_inventory_account
        find_employee.entries.create(
          commercial_document: find_customer,
          entry_date: order.date,
          description: "Payment for sales",
          debit_amounts_attributes: [{ amount: order.total_cost,
                                        account: accounts_receivable,
                                        commercial_document: order},
                                      { amount: order.cost_of_goods_sold,
                                        account: cost_of_goods_sold,
                                        commercial_document: order } ],
            credit_amounts_attributes:[{amount: order.total_cost,
                                        account: sales,
                                        commercial_document: order},
                                       {amount: order.cost_of_goods_sold,
                                        account: merchandise_inventory,
                                        commercial_document: order }])
      end
    end
  end
end
