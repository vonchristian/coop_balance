module StoreFrontModule
  class StockDelivery
    include ActiveModel::Model

    attr_accessor :supplier_id, :date, :expiry_date, :product_id, :voucher_id

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
