module Suppliers
  class StockPurchaseProcessing
    include ActiveModel::Model
    attr_accessor :product_id,
                  :date,
                  :quantity,
                  :barcode,
                  :supplier_id,
                  :purchase_cost,
                  :total_purchase_cost,
                  :selling_price,
                  :unit_of_measurement_id,
                  :registry_id
    validates :supplier_id, :product_id, :registry_id, :unit_of_measurement_id, presence: true
    validates :quantity, numericality: { greater_than: 0.01 }

    def process!
      ActiveRecord::Base.transaction do
        create_stock
      end
    end

    private
    def create_stock
      find_supplier.supplied_stocks.create( :product_id => product_id,
                                            :date => date,
                                            :quantity => quantity,
                                            :barcode => barcode,
                                            :purchase_cost => purchase_cost,
                                            :total_purchase_cost => total_purchase_cost,
                                            :unit_of_measurement_id => unit_of_measurement_id,
                                            :registry_id => registry_id)
    end

    def find_supplier
      Supplier.find_by_id(supplier_id)
    end
  end
end
