module StoreFrontModule
  class StockDelivery
    include ActiveModel::Model

    attr_reader :supplier_id, :date, :expiry_date, :product_id, :purchase_cost

    def save_delivery
      ActiveRecord::Base.transaction do
        save_delivery
      end
    end

    private
    def save_delivery
      find_supplier.delivered_stocks.create()
    end
  end
end
