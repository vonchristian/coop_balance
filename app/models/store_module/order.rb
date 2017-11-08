module StoreModule
  class Order < ApplicationRecord
    enum payment_type: [:cash, :credit, :check]
    belongs_to :customer, polymorphic: true
    belongs_to :employee, class_name: "User", foreign_key: 'employee_id'
    has_one :official_receipt, as: :receiptable
    has_one :charge_invoice, as: :invoicable
    delegate :number, to: :official_receipt, prefix: true, allow_nil: true
    delegate :first_and_last_name, to: :customer, prefix: true, allow_nil: true
    delegate :name, to: :customer, prefix: true, allow_nil: true
    has_many :line_items, class_name: "StoreModule::LineItem", dependent: :destroy

    validates :customer_id, presence: true
    after_commit :set_default_date, :set_customer_type, on: :create
    def self.customers
      Member.all + User.all
    end

    def add_line_items_from_cart(cart)
      cart.line_items.each do |item|
        item.cart_id = nil
        line_items << item
      end
    end
    def stock_cost
      line_items.sum(&:unit_cost_and_quantity)
    end

    def create_entry
      cash_on_hand = User.find_by(id: employee_id).cash_on_hand_account
      accounts_receivable = CoopConfigurationsModule::AccountReceivableStoreConfig.account_to_debit
      cost_of_goods_sold = AccountingModule::Account.find_by(name: "Cost of Goods Sold")
      sales = AccountingModule::Account.find_by(name: "Sales")
      merchandise_inventory = AccountingModule::Account.find_by(name: "Merchandise Inventory")
      if cash? || check?
        AccountingModule::Entry.cash_sale.create!( recorder_id: self.employee_id, commercial_document: self.customer, entry_date: self.date, description: "Payment for order",
          debit_amounts_attributes: [{amount: self.total_cost, account: cash_on_hand}, {amount: self.stock_cost, account: cost_of_goods_sold}],
          credit_amounts_attributes:[{amount: self.total_cost, account: sales}, {amount: self.stock_cost, account: merchandise_inventory}])
      elsif credit?
        AccountingModule::Entry.credit_sale.create!(commercial_document: self.customer, entry_date: self.date, description: "Credit order",
          debit_amounts_attributes: [{amount: self.total_cost, account: accounts_receivable}, {amount: self.stock_cost, account: cost_of_goods_sold}],
          credit_amounts_attributes:[{amount: self.total_cost, account: sales}, {amount: self.stock_cost, account: merchandise_inventory}])
      end
    end
    def badge_color
      if cash?
        'green'
      elsif credit?
        'red'
      end
    end

    private
    def set_default_date
      self.date ||= Time.zone.now
    end
    def set_customer_type
      if User.find_by(id: self.customer_id).present?
        self.customer_type = "User"
      elsif Member.find_by(id: self.customer_id).present?
        self.customer_type = "Member"
      end
    end
  end
end
