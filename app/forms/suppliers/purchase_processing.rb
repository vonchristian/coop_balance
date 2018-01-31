module Suppliers
  class PurchaseProcessing
    include ActiveModel::Model
    attr_accessor :supplier_id, :voucher_id, :registry_id, :payable_amount
    validates :registry_id, :voucher_id, presence: true

    def process!
      ActiveRecord::Base.transaction do
        process_delivery
      end
    end

    private
    def process_delivery
      registry = StockRegistry.create!
      registry.voucher = find_voucher
      find_registry.stocks.each do |stock|
        stock.registry = registry
        stock.save
      end
    end

    def find_voucher
      Voucher.find_by_id(voucher_id)
    end

    def find_registry
      Registry.find_by_id(registry_id)
    end
  end
end
