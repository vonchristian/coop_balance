module StoreFrontModule
  class PurchaseLineItemProcessing
    include ActiveModel::Model
    attr_accessor :commercial_document_id, :commercial_document_type, :unit_of_measurement_id, :quantity, :cart_id, :product_id, :unit_cost, :total_cost, :cart_id, :barcode

    def process!
      ActiveRecord::Base.transaction do
        process_purchase
      end
    end

    private
    def process_purchase
      find_cart.purchase_line_items.create(commercial_document_id: commercial_document_id,
                                  commercial_document_type: commercial_document_type,
                                  quantity: quantity,
                                  unit_cost: unit_cost,
                                  total_cost: total_cost,
                                  unit_of_measurement_id: unit_of_measurement_id,
                                  product_id: product_id)
    end
    def find_cart
      StoreFrontModule::Cart.find_by_id(cart_id)
    end
  end
end
