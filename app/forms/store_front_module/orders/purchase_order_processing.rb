module StoreFrontModule
  module Orders
    class PurchaseOrderProcessing
      include ActiveModel::Model
      attr_accessor :cart_id, :supplier_id, :voucher_id, :employee_id, :date, :description

      validates :voucher_id, :supplier_id, :description, presence: true
      def process!
        ActiveRecord::Base.transaction do
          create_purchase_order
        end
      end

      private

      def create_purchase_order
        order = StoreFrontModule::Orders::PurchaseOrder.create!(
          payee: find_supplier,
          credit: true,
          commercial_document: find_supplier,
          store_front: find_employee.store_front,
          cooperative: find_employee.cooperative,
          employee: find_employee
        )

        find_cart.purchase_line_items.each do |line_item|
          line_item.cart_id = nil
          order.purchase_line_items << line_item
        end

        order.save!

        create_voucher(order)
      end

      def find_supplier
        Supplier.find(supplier_id)
      end

      def find_cart
        Cart.find(cart_id)
      end

      def find_employee
        User.find(employee_id)
      end

      def create_voucher(order)
        StoreFrontModule::Vouchers::PurchaseOrder.new(order: order).create_voucher
      end
    end
  end
end
