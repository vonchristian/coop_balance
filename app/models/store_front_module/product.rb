module StoreFrontModule
  class Product < ApplicationRecord
    include PgSearch::Model
    multisearchable against: [:name]
    pg_search_scope :text_search,               against: [:name]
    pg_search_scope :text_search_with_barcode,  against: [:name],
                                                associated_against:  { :line_items => [:barcode] }
    belongs_to :store_front
    belongs_to :cooperative
    belongs_to :category,                       class_name: "StoreFrontModule::Category", optional: true
    has_many :unit_of_measurements,             class_name: "StoreFrontModule::UnitOfMeasurement", dependent: :destroy
    has_many :mark_up_prices,                   through: :unit_of_measurements
    has_many :line_items,                       class_name: "StoreFrontModule::LineItem"
    has_many :purchases,                        class_name: 'StoreFrontModule::LineItems::PurchaseLineItem'
    has_many :purchase_returns,                 class_name: "StoreFrontModule::LineItems::PurchaseReturnLineItem"
    has_many :sales,                            class_name: 'StoreFrontModule::LineItems::SalesLineItem'
    has_many :sales_returns,                    class_name: "StoreFrontModule::LineItems::SalesReturnLineItem"
    has_many :spoilages,                        class_name: "StoreFrontModule::LineItems::SpoilageLineItem"
    has_many :internal_uses,                    class_name: "StoreFrontModule::LineItems::InternalUseLineItem"
    has_many :stock_transfers,                  class_name: "StoreFrontModule::LineItems::StockTransferLineItem"
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


    validates :name, presence: true, uniqueness: true
    delegate :code, :price, to: :base_measurement, prefix: true, allow_nil: true

    def base_selling_price
      base_measurement.price
    end

    def current_price
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

    def balance(args={})
      purchases_balance(args) +
      received_stock_transfers_balance(args) +
      sales_returns_balance(args) -
      sales_balance(args) -
      internal_uses_balance(args) -
      spoilages_balance(args) -
      delivered_stock_transfers_balance -
      purchase_returns_balance(args)
    end

    def sales_balance(args={})
      sales.balance(args)
    end

    def purchases_balance(args={})
      purchases.balance(args)
    end

    def purchase_returns_balance(args={})
      purchase_returns.balance(args)
    end

    def sales_returns_balance(args={})
      sales_returns.balance(args)
    end

    def internal_uses_balance(args={})
      internal_uses.balance(args)
    end

    def received_stock_transfers_balance(args={})
      store_front = args[:store_front]
      if store_front.present?
        store_front.received_stock_transfer_line_items.balance(args)
      else
        0
      end
    end

    def delivered_stock_transfers_balance(args={})
      store_front = args[:store_front]
      if store_front.present?
        store_front.delivered_stock_transfer_line_items.balance(args)
      else
        0
      end
    end

    def spoilages_balance(args={})
      spoilages.balance(args)
    end
  end
end
