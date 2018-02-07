module StoreFrontModule
  module Orders
    class PurchaseOrderProcessing
      include ActiveModel::Model
      attr_accessor  :cart_id, :supplier_id, :voucher_id, :employee_id, :date
      validates :voucher_id, :supplier_id, presence: true
      def process!
        ActiveRecord::Base.transaction do
          create_purchase_order
        end
      end

      private
      def create_purchase_order
        order = find_supplier.purchase_orders.create(voucher: find_voucher, employee_id: employee_id)
        find_cart.purchase_order_line_items.each do |line_item|
          line_item.cart_id = nil
          order.purchase_order_line_items << line_item
        end
        create_entry(order)
      end
      def create_entry(order)
        accounts_payable = CoopConfigurationsModule::StoreFrontConfig.default_accounts_payable_account
        merchandise_inventory = CoopConfigurationsModule::StoreFrontConfig.default_merchandise_inventory_account
        find_employee.entries.create(
          commercial_document: find_supplier,
          entry_date: order.date,
          description: "Purchase of stocks from #{find_supplier.business_name}",
          debit_amounts_attributes: [ amount: order.total_cost,
                                      account: merchandise_inventory,
                                      commercial_document: find_supplier],
            credit_amounts_attributes:[amount: order.total_cost,
                                       account:accounts_payable,
                                       commercial_document: find_supplier])
      end
      def find_supplier
        Supplier.find_by_id(supplier_id)
      end
      def find_voucher
        Voucher.find_by_id(voucher_id)
      end
      def find_cart
        Cart.find_by_id(cart_id)
      end
      def find_employee
        User.find_by_id(employee_id)
      end
    end
  end
end
