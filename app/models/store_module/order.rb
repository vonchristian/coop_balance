module StoreModule  
  class Order < ApplicationRecord
    enum payment_type: [:cash, :credit, :check]
    belongs_to :member
    has_one :official_receipt
    delegate :number, to: :official_receipt, prefix: true
    has_many :line_items, class_name: "StoreModule::LineItem"
    def total_cost 
      line_items.sum(:total_cost)
    end
    def add_line_items_from_cart(cart)
      cart.line_items.each do |item|
        item.cart_id = nil
        line_items << item
      end
    end
  end
end