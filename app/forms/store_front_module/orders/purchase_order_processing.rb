module StoreFrontModule
  module Orders
    class PurchaseOrderProcessing
      include ActiveModel::Model
      attr_accessor  :cart_id, :supplier_id, :voucher_id, :employee_id, :date, :description
      validates :voucher_id, :supplier_id, :description, presence: true
      def process!
        ActiveRecord::Base.transaction do
          create_purchase_order
        end
      end

      private
      def create_purchase_order
        order = find_supplier.purchase_orders.create!(voucher: find_voucher, employee_id: employee_id)
        find_cart.purchase_line_items.each do |line_item|
          line_item.cart_id = nil
          order.purchase_line_items << line_item
        end
        order.voucher = find_voucher
        order.save
      end


      def update_voucher(order)
        find_voucher.commercial_document = order
        find_voucher.save
      end
      def find_supplier
        Supplier.find(supplier_id)
      end
      def find_voucher
        Voucher.find(voucher_id)
      end
      def find_cart
        Cart.find(cart_id)
      end
      def find_employee
        User.find(employee_id)
      end


    end

  end
end
