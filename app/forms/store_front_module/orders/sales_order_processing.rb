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
        order = StoreFrontModule::Orders::SalesOrder.create(
        commercial_document: find_customer,
        cash_tendered: cash_tendered,
        order_change: order_change,
        date: date,
        employee: find_employee)

        find_cart.sales_line_items.each do |sales_line_item|
          sales_line_item.cart_id = nil
          order.sales_line_items << sales_line_item
        end
        create_entry(order)
      end

      def find_customer
        Customer.find(customer_id)
      end

      def find_cart
        Cart.find_by_id(cart_id)
      end

      def find_employee
        User.find_by_id(employee_id)
      end

      def create_entry(order)
        store_front = find_employee.store_front
        cash_on_hand = find_cash_account
        cost_of_goods_sold = store_front.cost_of_goods_sold_account
        sales = store_front.sales_account
        sales_discount = store_front.sales_discount_account
        merchandise_inventory = store_front.merchandise_inventory_account
        find_employee.entries.create!(
          office: find_employee.office,
          cooperative: find_employee.cooperative,
          previous_entry: find_employee.cooperative.entries.recent,
          recorder: find_employee,
          commercial_document: find_customer,
          entry_date: order.date,
          description: "Payment for sales",
          debit_amounts_attributes: [ { amount: total_cost_less_discount(order),
                                        account: cash_on_hand,
                                        commercial_document: order},
                                      { amount: discount_amount,
                                        account: sales_discount,
                                        commercial_document: order},
                                      { amount: order.cost_of_goods_sold,
                                        account: cost_of_goods_sold,
                                        commercial_document: order } ],
          credit_amounts_attributes:[ { amount: order.total_cost,
                                        account: sales,
                                        commercial_document: order},
                                      { amount: order.cost_of_goods_sold,
                                        account: merchandise_inventory,
                                        commercial_document: order}])
      end
      def total_cost_less_discount(order)
        order.total_cost - discount_amount.to_f
      end
      def find_cash_account
        find_employee.cash_accounts.find(cash_account_id)
      end
    end
  end
end
