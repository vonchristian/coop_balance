module StoreFrontModule
  module Orders
    class PurchaseOrderProcessing
      include ActiveModel::Model
      attr_accessor  :cart_id, :commercial_document_id, :commercial_document_type, :voucher_id, :employee_id
        validates :voucher_id, presence: true
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
      end

      def find_supplier
        Supplier.find_by_id(commercial_document_id)
      end
      def find_voucher
        Voucher.find_by_id(voucher_id)
      end
      def find_cart
        Cart.find_by_id(cart_id)
      end
    end
  end
end
