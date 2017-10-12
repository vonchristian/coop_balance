class StockRegistry < Registry 
  has_one :voucher, foreign_key: 'voucherable_id', class_name: "Voucher", dependent: :destroy
  delegate :number, to: :voucher, prefix: true, allow_nil: true
  belongs_to :supplier, optional: true
  has_many :stocks, class_name: "StoreModule::ProductStock", foreign_key: 'registry_id', dependent: :destroy
  def payable_amount 
    stocks.sum(:total_cost)
  end

  def self.transfer_stocks_from(old_registry, supplier)
    new_registry = StockRegistry.create(supplier: supplier)
    new_registry.voucher = old_registry.voucher
    new_registry.stocks << old_registry.stocks 
  end 
end