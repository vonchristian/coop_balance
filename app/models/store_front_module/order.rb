module StoreFrontModule
  class Order < ApplicationRecord
    enum pay_type: [:cash, :credit, :check]
    belongs_to :commercial_document, polymorphic: true
    belongs_to :employee, class_name: "User", foreign_key: 'employee_id'
    belongs_to :store_front
    has_one :official_receipt, as: :receiptable
    has_one :entry, as: :commercial_document, class_name: "AccountingModule::Entry"
    has_one :invoice, as: :invoiceable

    has_many :sale_line_items, extend: StoreFrontModule::QuantityBalanceFinder, class_name: "StoreFrontModule::SaleLineItem", inverse_of: :order
    has_many :purchase_line_items, extend: StoreFrontModule::QuantityBalanceFinder, class_name: "StoreFrontModule::PurchaseLineItem", inverse_of: :order
    has_many :line_items, class_name: "StoreFrontModule::LineItem"
    has_many :products, class_name: "StoreFrontModule::Product", through: :line_items

    delegate :number, to: :official_receipt, prefix: true, allow_nil: true
    delegate :number, to: :invoice, prefix: true, allow_nil: true

    validates :customer_id, presence: true
    def self.total(options={})
      if options[:from_date] && options[:to_date]
        from_date = Chronic.parse(options[:from_date].to_date)
        to_date = Chronic.parse(options[:to_date].to_date)
        where('date' => (from_date.beginning_of_day)..(to_date.end_of_day)).sum(:total_cost)
      else
        sum(:total_cost)
      end
    end
    def reference_number
      official_receipt_number || invoice_number
    end
    def self.customers
      Member.all + User.all
    end


    def stock_cost
      line_items.sum(&:unit_cost_and_quantity)
    end


    def badge_color
      if cash? || check?
        'green'
      elsif credit?
        'red'
      end
    end
  end
end
