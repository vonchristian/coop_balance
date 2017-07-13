module StoreModule  
  class Order < ApplicationRecord
    enum payment_type: [:cash, :credit, :check]
    belongs_to :member
    has_one :official_receipt, as: :receiptable
    delegate :number, to: :official_receipt, prefix: true, allow_nil: true
    has_many :line_items, class_name: "StoreModule::LineItem", dependent: :destroy

    validates :member_id, presence: true
    after_commit :set_default_date, on: :create
    def total_cost 
      line_items.sum(:total_cost)
    end
    def add_line_items_from_cart(cart)
      cart.line_items.each do |item|
        item.cart_id = nil
        line_items << item
      end
    end
    private 
    def set_default_date 
      self.date ||= Time.zone.now 
    end
  end
end