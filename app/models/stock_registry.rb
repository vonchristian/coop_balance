class StockRegistry < Registry
  has_one :voucher,  as: :commercial_document, dependent: :destroy
  delegate :number, to: :voucher, prefix: true, allow_nil: true
  belongs_to :supplier, optional: true
  has_many :stocks, class_name: "StoreFrontModule::ProductStock", foreign_key: 'registry_id', dependent: :destroy
  def payable_amount
    stocks.sum(:total_purchase_cost)
  end

  def self.transfer_stocks_from(old_registry, supplier)
    new_registry = StockRegistry.create(supplier: supplier)
    new_registry.voucher = old_registry.voucher
    new_registry.stocks << old_registry.stocks
  end

end
