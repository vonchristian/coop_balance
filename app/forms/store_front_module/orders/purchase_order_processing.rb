module StoreFrontModule
  module Orders
    class PurchaseOrderProcessing
      include ActiveModel::Model
      attr_accessor  :cart_id, :supplier_id, :voucher_id, :employee_id, :date, :description
      validates :voucher_id, :supplier_id, :description, presence: true
      validate :ensure_amounts_cancel?
      def process!
        ActiveRecord::Base.transaction do
          create_purchase_order
        end
      end

      private
      def create_purchase_order
        order = find_supplier.purchase_orders.create(voucher: find_voucher, employee_id: employee_id)
        find_cart.purchase_line_items.each do |line_item|
          line_item.cart_id = nil
          order.purchase_line_items << line_item
        end
        create_entry(order)
        order.voucher = find_voucher
        order.save
      end

      def create_entry(order)
        store_front = find_employee.store_front
        accounts_payable = store_front.accounts_payable_account
        merchandise_inventory = store_front.merchandise_inventory_account
        find_employee.entries.create(
          origin: find_employee.office,
          commercial_document: find_supplier,
          entry_date: order.date,
          description: description,
          debit_amounts_attributes: [ amount: order.total_cost,
                                      account: merchandise_inventory,
                                      commercial_document: find_supplier
                                    ],
          credit_amounts_attributes:[ amount: order.total_cost,
                                      account:accounts_payable,
                                      commercial_document: find_supplier
                                    ])
      end
      def update_voucher(order)
        find_voucher.commercial_document = order
        find_voucher.save
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
      private
      def ensure_amounts_cancel?
        errors[:base] << "The total cost and voucher amounts are not equal" if find_voucher.total  != find_cart.total_cost
      end
    end

  end
end
