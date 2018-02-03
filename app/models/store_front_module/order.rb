module StoreFrontModule
  class Order < ApplicationRecord
    enum pay_type: [:cash, :credit, :check]
    belongs_to :employee, class_name: "User", foreign_key: 'employee_id'
    belongs_to :store_front
    has_one :official_receipt, as: :receiptable
    has_one :invoice, as: :invoiceable
    has_one :entry,                       class_name: "AccountingModule::Entry", as: :commercial_document
    has_many :sale_line_items,            class_name: "StoreFrontModule::SaleLineItem", inverse_of: :order,
                                          extend: StoreFrontModule::QuantityBalanceFinder
    has_many :purchase_line_items,        class_name: "StoreFrontModule::PurchaseLineItem", inverse_of: :order,
                                          extend: StoreFrontModule::QuantityBalanceFinder
    has_many :sales_return_line_items,    class_name: "StoreFrontModule::SalesReturnLineItem"
    has_many :purchase_return_line_items, class_name: "PurchaseReturnLineItem"
    has_many :products,                   class_name: "StoreFrontModule::Product", through: :line_items

    delegate :number,                     to: :official_receipt, prefix: true, allow_nil: true
    delegate :number,                     to: :invoice, prefix: true, allow_nil: true
    delegate :first_and_last_name,        to: :commercial_document, prefix: true

    def self.total(options={})
      if options[:from_date] && options[:to_date]
        date_range = DateRange.new(from_date: options[:from_date], to_date: options[:to_date])
        where('date' => (date_range.start_date..date_range.end_date)).sum(:total_cost)
      else
        sum(:total_cost)
      end
    end

    def reference_number
      if cash? || check?
        official_receipt_number
      else
        invoice_number
      end
    end

    def self.customers
      Member.all + User.all
    end


    def cost_of_goods_sold
      line_items.sum(&:cost_of_goods_sold)
    end

    def total_cost
      line_items.sum(&:total_cost)
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
