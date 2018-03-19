module StoreFrontModule
  module Orders
    class PurchaseOrder < Order
      has_one :voucher, as: :payee
      has_many :purchase_line_items, class_name: "StoreFrontModule::LineItems::PurchaseLineItem", foreign_key: 'order_id'
      has_many :products, class_name: "StoreFrontModule::Product", through: :purchase_order_line_items

      delegate :number, :date, :disburser_full_name,  to: :voucher, prefix: true, allow_nil: true
      delegate :name, to: :supplier, prefix: true

      def self.processed
        select{ |a| a.processed? }
      end

      def processed?
        voucher.present?
      end

      def supplier
        commercial_document
      end
      def line_items_quantity(product)
        purchase_order_line_items.where(product: product).sum(&:quantity)
      end

      def line_items_total_cost(product)
        purchase_order_line_items.where(product: product).sum(&:total_cost)
      end
    end
  end
end
