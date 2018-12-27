module StoreFrontModule
  class Product < ApplicationRecord
    include PgSearch
    extend StoreFrontModule::QuantityBalanceFinder
    multisearchable against: [:name]
    pg_search_scope :text_search,               against: [:name]
    pg_search_scope :text_search_with_barcode,  against: [:name],
                                                associated_against:  { :line_items => [:barcode] }
    belongs_to :cooperative
    belongs_to :store_front
    belongs_to :category,                       class_name: "StoreFrontModule::Category", optional: true
    has_many :unit_of_measurements,             class_name: "StoreFrontModule::UnitOfMeasurement"
    has_many :line_items,                       class_name: "StoreFrontModule::LineItem"
    has_many :purchases,                        class_name: 'StoreFrontModule::LineItems::PurchaseLineItem'
    has_many :sales,                            class_name: 'StoreFrontModule::LineItems::SalesLineItem'
    has_many :sales_returns,                    class_name: "StoreFrontModule::LineItems::SalesReturnLineItem"
    has_many :purchase_returns,                 class_name: "StoreFrontModule::LineItems::PurchaseReturnLineItem"
    has_many :spoilages,                        class_name: "StoreFrontModule::LineItems::SpoilageLineItem"
    has_many :internal_uses,                    class_name: "StoreFrontModule::LineItems::InternalUseLineItem"
    has_many :stock_transfers,                  class_name: "StoreFrontModule::LineItems::StockTransferLineItem"
    has_many :received_stock_transfers,         class_name: "StoreFrontModule::LineItems::ReceivedStockTransferLineItem"
    has_many :orders,                           through: :line_items,
                                                source: :order
    has_many :sales_orders,                     :through => :sales,
                                                :source => :sales_order,
                                                :class_name => 'StoreFrontModule::Orders::SalesOrder'
    has_many :purchase_orders,                  :through => :purchases,
                                                :source => :purchase_order,
                                                :class_name => 'StoreFrontModule::Orders::PurchaseOrder'
    has_many :purchase_return_orders,           class_name: "StoreFrontModule::Orders::PurchaseReturnOrder",
                                                through: :purchase_returns,
                                                source: :purchase_return_order
    has_many :sales_return_orders,              class_name: "StoreFrontModule::Orders::SalesReturnOrder",
                                                through: :sales_returns,
                                                source: :sales_return_order
    has_many :internal_use_orders,              class_name: "StoreFrontModule::Orders::InternalUseOrder",
                                                through: :internal_uses,
                                                source: :internal_use_order
    has_many :spoilage_orders,                  class_name: "StoreFrontModule::Orders::SpoilageOrder",
                                                through: :spoilages,
                                                source: :spoilage_order
    has_many :stock_transfer_orders,            class_name: "StoreFrontModule::Orders::StockTransferOrder",
                                                through: :stock_transfers,
                                                source: :stock_transfer_order
    has_many :received_stock_transfer_orders,    class_name: "StoreFrontModule::Orders::ReceivedStockTransferOrder",
                                                through: :received_stock_transfers,
                                                source: :received_stock_transfer_order


    validates :name, presence: true, uniqueness: true
    delegate :code, :price, to: :base_measurement, prefix: true

    def base_selling_price
      base_measurement.price
    end

    def base_measurement
      unit_of_measurements.base_measurement.recent
    end

    def out_of_stock?
      balance.zero?
    end

    def last_purchase_cost
      purchases.processed.order(created_at: :asc).last.try(:unit_cost)
    end

    def balance(options={})
      received_stock_transfers_balance(options) +
      sales_returns_balance(options) +
      purchases_balance(options) -
      sales_balance(options) -
      internal_uses_balance(options) -
      spoilages_balance(options) -
      stock_transfers_balance(options) -
      purchase_returns_balance(options)
    end

    def sales_balance(options={})
      sales.processed.balance(self)
    end

    def purchases_balance(options={})
      purchases.processed.balance(self)
    end

    def purchase_returns_balance(options={})
      purchase_returns.processed.balance(self)
    end

    def sales_returns_balance(options={})
      sales_returns.processed.balance(self)
    end

    def internal_uses_balance(options={})
      internal_uses.processed.balance(self)
    end

    def stock_transfers_balance(options={})
      stock_transfers.processed.balance(self)
    end

    def received_stock_transfers_balance(options={})
      received_stock_transfers.processed.balance(self)
    end

    def spoilages_balance(options={})
      spoilages.processed.balance(self)
    end


    def available_quantity
      balance
    end
  end
end
