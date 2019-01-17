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
        cooperative: find_cooperative,
        commercial_document: find_customer,
        cash_tendered: cash_tendered,
        order_change: order_change,
        date: date,
        employee: find_employee)

        find_cart.sales_line_items.each do |sales_line_item|
          sales_line_item.cart_id = nil
          order.sales_line_items << sales_line_item
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
        StoreFrontModule::Vouchers::SalesOrderVoucher.new(order: order).create_voucher!
        store_front = find_employee.store_front
        cash_on_hand = find_cash_account
        cost_of_goods_sold = store_front.cost_of_goods_sold_account
        sales = store_front.sales_account
        sales_discount = store_front.sales_discount_account
        merchandise_inventory = store_front.merchandise_inventory_account

        voucher = find_cooperative.vouchers.build(
          payee: find_customer,
          office: find_employee.office,
          preparer: find_employee,
          date: date,
          description: "Sales order ##{order.reference_number}",
          reference_number: reference_number,
          number: Voucher.generate_number,
          account_number: SecureRandom.uuid
        )

        voucher.voucher_amounts.debit.build(
          amount: total_cost_less_discount(order),
          account: cash_on_hand,
          commercial_document: order
        )
        voucher.voucher_amounts.debit.build(
          amount: discount_amount,
          account: sales_discount,
          commercial_document: order
        )
        voucher.voucher_amounts.debit.build(
          amount: order.cost_of_goods_sold,
          account: cost_of_goods_sold,
          commercial_document: order
        )

        voucher.voucher_amounts.credit.build(
          amount: order.total_cost,
          account: sales,
          commercial_document: order
        )

        voucher.voucher_amounts.credit.build(
          amount: order.cost_of_goods_sold,
          account: merchandise_inventory,
          commercial_document: order
        )

        voucher.save!
        create_entry(voucher)
      end
      def create_entry(voucher)
        entry = find_employee.entries.build(
          office: find_employee.office,
          cooperative: find_employee.cooperative,
          previous_entry: find_employee.cooperative.entries.recent,
          recorder: find_employee,
          commercial_document: find_customer,
          entry_date: voucher.date,
          description: "Payment for sales")
          voucher.voucher_amounts.debit.each do |voucher_amount|
            entry.debit_amounts.build(
              amount: voucher_amount.amount,
              account: voucher_amount.account,
              commercial_document: voucher_amount.commercial_document
            )
          end
          voucher.voucher_amounts.credit.each do |voucher_amount|
            entry.credit_amounts.build(
              amount: voucher_amount.amount,
              account: voucher_amount.account,
              commercial_document: voucher_amount.commercial_document
            )
          end
        entry.save!
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
