module StoreFrontModule
  module Orders
    class PurchaseReturnOrderProcessing
      include ActiveModel::Model
      attr_accessor :cart_id, :supplier_id, :employee_id, :date

      def process!
        ActiveRecord::Base.transaction do
          create_purchase_return_order
        end
      end

      private

      def create_purchase_return_order
        order = find_supplier.purchase_return_orders.create!(date: date, employee_id: employee_id)
        find_cart.purchase_return_line_items.each do |line_item|
          line_item.cart_id = nil
          order.purchase_return_line_items << line_item
        end
        create_entry(order)
      end

      def create_entry(order)
        store_front = find_employee.store_front
        accounts_payable = store_front.accounts_payable_account
        merchandise_inventory = store_front.merchandise_inventory_account
        find_employee.entries.create!(
          origin: find_employee.office,
          commercial_document: find_supplier,
          entry_date: order.date,
          description: "Purchase return of stocks to #{find_supplier.business_name}",
          debit_amounts_attributes: [ amount: order.total_cost,
                                     account: accounts_payable,
                                     commercial_document: find_supplier ],
          credit_amounts_attributes: [ amount: order.total_cost,
                                      account: merchandise_inventory,
                                      commercial_document: find_supplier ]
        )
      end

      def find_supplier
        Supplier.find_by(id: supplier_id)
      end

      def find_cart
        StoreFrontModule::Cart.find_by(id: cart_id)
      end

      def find_employee
        User.find_by(id: employee_id)
      end
    end
  end
end
