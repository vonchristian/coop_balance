module StoreFrontModule
  class Order < ApplicationRecord
    enum pay_type: [:cash, :credit, :check]
    belongs_to :employee, class_name: "User", foreign_key: 'employee_id'
    belongs_to :commercial_document, polymorphic: true
    belongs_to :store_front
    has_one :official_receipt, as: :receiptable
    has_one :invoice, as: :invoiceable
    has_many :line_items, class_name: "StoreFrontModule::LineItem", dependent: :destroy
    has_many :sale_line_items,            class_name: "StoreFrontModule::SaleLineItem", inverse_of: :order,
                                          extend: StoreFrontModule::QuantityBalanceFinder
    has_many :purchase_line_items,        class_name: "StoreFrontModule::PurchaseLineItem", inverse_of: :order,
                                          extend: StoreFrontModule::QuantityBalanceFinder
    has_many :sales_return_line_items,    class_name: "StoreFrontModule::SalesReturnLineItem"
    has_many :purchase_return_line_items, class_name: "PurchaseReturnLineItem"
    has_many :products,                   class_name: "StoreFrontModule::Product", through: :line_items
    delegate :name,                       to: :commercial_document, prefix: true
    delegate :name,                       to: :employee, prefix: true, allow_nil: true
    delegate :number,                     to: :official_receipt, prefix: true, allow_nil: true
    delegate :number,                     to: :invoice, prefix: true, allow_nil: true
    delegate :first_and_last_name,        to: :commercial_document, prefix: true
    before_save :set_default_date
    def self.ordered_on(options={})
      if options[:from_date] && options[:to_date]
        date_range = DateRange.new(from_date: options[:from_date], to_date: options[:to_date])
        where('date' => (date_range.start_date..date_range.end_date))
      else
        all
      end
    end

    def self.total(options={})
      ordered_on(options).sum(&:total_cost)
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

    private
    def set_default_date
        todays_date = ActiveRecord::Base.default_timezone == :utc ? Time.now.utc : Time.now
        self.date ||= todays_date
      end
  end
end
