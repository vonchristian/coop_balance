module StoreFrontModule
  class Order < ApplicationRecord
    include PgSearch::Model
    pg_search_scope :text_search, against: [ :commercial_document_name ]

    enum :pay_type, { cash: 0, check: 1 }

    belongs_to :employee,                 class_name: "User"
    belongs_to :commercial_document,      polymorphic: true
    belongs_to :store_front
    belongs_to :cooperative
    belongs_to :voucher, class_name: "TreasuryModule::Voucher"

    has_many :line_items,                 class_name: "StoreFrontModule::LineItem", dependent: :destroy
    has_many :products,                   class_name: "StoreFrontModule::Product", through: :line_items

    delegate :name,                       to: :commercial_document, prefix: true
    delegate :name,                       to: :employee, prefix: true, allow_nil: true
    delegate :first_and_last_name,        to: :commercial_document, prefix: true
    delegate :avatar,                     to: :commercial_document

    before_save :set_default_date, :set_commercial_document_name

    def self.processed
      joins(:voucher).merge(TreasuryModule::Voucher.disbursed)
    end

    def self.ordered_on(options = {})
      if options[:from_date] && options[:to_date]
        date_range = DateRange.new(from_date: options[:from_date], to_date: options[:to_date])
        where("date" => (date_range.start_date..date_range.end_date))
      else
        all
      end
    end

    def self.total(options = {})
      ordered_on(options).sum(&:total_cost)
    end

    def reference_number; end

    def processed?
      voucher&.disbursed?
    end

    def cost_of_goods_sold
      line_items.sum(&:cost_of_goods_sold)
    end

    def total_cost
      line_items.sum(&:total_cost)
    end

    def badge_color
      if cash? || check?
        "green"
      elsif credit?
        "red"
      end
    end

    private

    def set_default_date
      self.date ||= Time.zone.now
    end

    # pg_search cannot traverse polymorphic association
    def set_commercial_document_name
      self.commercial_document_name = commercial_document.name
    end
  end
end
