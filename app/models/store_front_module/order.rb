module StoreFrontModule
  class Order < ApplicationRecord
    include PgSearch
    pg_search_scope :text_search, against: [:commercial_document_name]

    enum pay_type: [:cash, :check]

    belongs_to :employee,                 class_name: "User", foreign_key: 'employee_id'
    belongs_to :commercial_document,      polymorphic: true
    belongs_to :store_front
    belongs_to :cooperative
    belongs_to :voucher

    has_one :official_receipt,            as: :receiptable
    has_one :invoice,                     as: :invoiceable
    has_many :line_items,                 class_name: "StoreFrontModule::LineItem", dependent: :destroy
    has_many :products,                   class_name: "StoreFrontModule::Product", through: :line_items

    delegate :name,                       to: :commercial_document, prefix: true
    delegate :name,                       to: :employee, prefix: true, allow_nil: true
    delegate :number,                     to: :official_receipt, prefix: true, allow_nil: true
    delegate :number,                     to: :invoice, prefix: true, allow_nil: true
    delegate :first_and_last_name,        to: :commercial_document, prefix: true
    delegate :avatar,                     to: :commercial_document

    before_save :set_default_date, :set_commercial_document_name

    def self.processed
      joins(:voucher).merge(Voucher.disbursed)
    end

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

    def processed?
      voucher && voucher.disbursed?
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
    def set_commercial_document_name #pg_search cannot traverse polymorphic association
      self.commercial_document_name = self.commercial_document.name
    end
  end
end
