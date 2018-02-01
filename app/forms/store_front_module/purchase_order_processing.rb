module StoreFrontModule
  class PurchaseOrderProcessing
    include ActiveModel::Model

    attr_accessor :voucher_id, :supplier_id, :cart_id

    def process!
      ActiveRecord::Base.transaction do
        process_purchase_order
      end
    end

    private
    def process_purchase_order
      create_order
    end
    def create_order
      order = StoreFrontModule::Order.create!(
        commercial_document: find_supplier,
        date: Date.today)
      remove_cart_reference(order)

    end
    def find_supplier
      Supplier.find_by_id(:supplier_id)
    end
    def remove_cart_reference(order)
      StoreFrontModule::Cart.find_by(id: cart_id).line_items.each do |item|
        item.cart_id = nil
        order.purchase_line_items << item
      end
    end
  end
end
