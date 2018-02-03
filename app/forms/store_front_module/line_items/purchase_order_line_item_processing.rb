module StoreFrontModule
  module LineItems
    class PurchaseOrderLineItemProcessing
     include ActiveModel::Model
      attr_accessor :commercial_document_id, :commercial_document_type, :unit_of_measurement_id, :quantity, :cart_id, :product_id, :unit_cost, :total_cost, :cart_id, :barcode, :referenced_line_item_id

      def process!
        ActiveRecord::Base.transaction do
          process_purchase
        end
      end

      private
      def process_purchase
        line_item = find_cart.purchase_order_line_items.create(commercial_document_id: commercial_document_id,
                                    commercial_document_type: commercial_document_type,
                                    quantity: quantity,
                                    unit_cost: unit_cost,
                                    total_cost: total_cost,
                                    unit_of_measurement_id: unit_of_measurement_id,
                                    product_id: product_id,
                                    barcode: barcode
                                    )
      end
      def find_cart
        StoreFrontModule::Cart.find_by_id(cart_id)
      end
    end
  end
end
