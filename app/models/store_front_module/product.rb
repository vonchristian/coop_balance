module StoreFrontModule
  class Product < ApplicationRecord
    include PgSearch
    multisearchable against: [:name]
    pg_search_scope :text_search, against: [:name]
    pg_search_scope :text_search_with_barcode, against: [:name],   associated_against:  { :line_items => [:barcode] }

    belongs_to :category, class_name: "StoreFrontModule::Category", optional: true
    has_many :unit_of_measurements, class_name: "StoreFrontModule::UnitOfMeasurement"
    has_many :line_items, class_name: "StoreFrontModule::LineItem"

    has_many :purchases, :class_name => 'StoreFrontModule::LineItems::PurchaseOrderLineItem'
    has_many :sales, :class_name => 'StoreFrontModule::LineItems::SalesOrderLineItem'
    has_many :orders, through: :line_items, source: :order
    has_many :sales_orders, :through => :sales, :source => :order, :class_name => 'StoreFrontModule::Orders::SalesOrder'
    has_many :purchase_orders, :through => :purchases, :source => :order, :class_name => 'StoreFrontModule::Orders::PurchaseOrder'
    has_many :sales_returns, class_name: "StoreFrontModule::LineItems::SalesReturnOrderLineItem"
    has_many :purchase_returns, class_name: "StoreFrontModule::LineItems::PurchaseReturnOrderLineItem"
    has_many :spoilages, class_name: "StoreFrontModule::LineItems::SpoilageOrderLineItem"
    has_attached_file :photo,
    styles: { large: "120x120>",
             medium: "70x70>",
             thumb: "40x40>",
             small: "30x30>",
             x_small: "20x20>"},
    default_url: ":style/default_product.jpg",
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"
    validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
    validates_attachment_size :photo, :in => 0.megabytes..4.megabytes, :message => 'must be smaller than 4mb'

    validates :name, presence: true, uniqueness: true
    delegate :code, :price, to: :base_measurement, prefix: true
    def base_selling_price
      base_measurement.price
    end
    def base_measurement
      unit_of_measurements.base_measurement
    end

    def out_of_stock?
      balance.zero?
    end

    def balance(options={})
      purchases_balance(options) - sales_balance(options)
    end

    def sales_balance(options={})
      sales.balance(product_id: self.id) -
      sales_returns.balance(product_id: self.id)
    end

    def purchases_balance(options={})
      purchases.balance(product_id: self.id) -
      purchase_returns.balance(product_id: self.id) -
      spoilages.balance(product_id: self.id)
    end
    def purchase_returns_balance(options={})
      purchase_returns.balance(product_id: self.id)
    end

    def sales_returns_balance(options={})
      sales_returns.balance(product_id: self.id)
    end

    def available_quantity
      balance
    end
  end
end
