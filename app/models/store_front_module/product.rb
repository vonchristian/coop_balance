module StoreFrontModule
  class Product < ApplicationRecord
    include PgSearch
    multisearchable against: [:name]
    pg_search_scope :text_search, against: [:name], :associated_against => {
    :stocks => [:barcode] }
    belongs_to :category, class_name: "StoreFrontModule::Category"
    has_many :stocks, class_name: "StoreFrontModule::ProductStock"
    has_many :sold_items, through: :stocks, source: :sold_items
    has_many :orders, through: :sold_items
    has_many :unit_of_measurements
    has_many :line_items, class_name: "StoreFrontModule::LineItem"
    has_many :credit_line_items, :class_name => 'StoreFrontModule::CreditLineItem'
    has_many :debit_line_items,  :class_name => 'StoreFrontModule::DebitLineItem'
    has_many :orders, through: :line_items, source: :order
    has_many :credit_orders, :through => :credit_line_items, :source => :order, :class_name => 'StoreFrontModule::Order'
    has_many :debit_orders, :through => :debit_line_items, :source => :order, :class_name => 'StoreFrontModule::Order'
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
    def base_measurement
      unit_of_measurements.base_measurement
    end

    def out_of_stock?
      balance.zero?
    end

    def balance(options={})
      credits_balance(options) - debits_balance(options)
    end

    def credits_balance(options={})
      credit_line_items.balance(options)
    end

    def debits_balance(options={})
      debit_line_items.balance(options)
    end
  end
end
