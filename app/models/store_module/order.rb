module StoreModule
  class Order < ApplicationRecord
    enum pay_type: [:cash, :credit, :check]
    belongs_to :customer, polymorphic: true
    belongs_to :employee, class_name: "User", foreign_key: 'employee_id'
    has_one :official_receipt, as: :receiptable
    has_one :entry, as: :commercial_document, class_name: "AccountingModule::Entry"
    has_one :charge_invoice, as: :invoicable
    delegate :number, to: :official_receipt, prefix: true, allow_nil: true
    delegate :first_and_last_name, to: :customer, prefix: true, allow_nil: true
    delegate :name, to: :customer, prefix: true, allow_nil: true
    has_many :line_items, class_name: "StoreModule::LineItem", dependent: :destroy

    validates :customer_id, presence: true
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
