class StoreFront < ApplicationRecord
  belongs_to :cooperative
  belongs_to :cooperative_service, class_name: "Cooperatives::CooperativeService"

  belongs_to :receivable_account,            class_name: "AccountingModule::Account", foreign_key: 'receivable_account_id'
  belongs_to :cost_of_goods_sold_account,    class_name: "AccountingModule::Account", foreign_key: 'cost_of_goods_sold_account_id'
  belongs_to :merchandise_inventory_account, class_name: "AccountingModule::Account", foreign_key: 'merchandise_inventory_account_id'
  belongs_to :sales_account,                 class_name: "AccountingModule::Account", foreign_key: 'sales_account_id'
  belongs_to :sales_return_account,          class_name: "AccountingModule::Account", foreign_key: 'sales_return_account_id'
  belongs_to :payable_account,               class_name: "AccountingModule::Account", foreign_key: 'payable_account_id'
  belongs_to :spoilage_account,              class_name: "AccountingModule::Account", foreign_key: 'spoilage_account_id'
  belongs_to :sales_discount_account,        class_name: "AccountingModule::Account", foreign_key: 'sales_discount_account_id'
  belongs_to :purchase_return_account,       class_name: "AccountingModule::Account", foreign_key: 'purchase_return_account_id'
  belongs_to :internal_use_account,          class_name: "AccountingModule::Account", foreign_key: 'internal_use_account_id'
  has_many :entries,                         class_name: "AccountingModule::Entry",
                                             as: :origin
  has_many :products,                        class_name: "StoreFrontModule::Product"
  has_many :purchase_orders,                 class_name: "StoreFrontModule::Orders::PurchaseOrder"
  has_many :purchase_line_items,                 through: :purchase_orders
  has_many :received_stock_transfers,            class_name: "StoreFrontModule::Orders::PurchaseOrder", foreign_key: 'destination_store_front_id'
  has_many :delivered_stock_transfers,           class_name: "StoreFrontModule::Orders::PurchaseOrder", as: :supplier
  has_many :received_stock_transfer_line_items,  class_name: "StoreFrontModule::LineItems::PurchaseLineItem", through: :received_stock_transfers, source: :purchase_line_items
  has_many :delivered_stock_transfer_line_items, class_name: "StoreFrontModule::LineItems::PurchaseLineItem"
  has_many :orders,                              class_name: "StoreFrontModule::Order"
  has_many :line_items,                          through: :orders, class_name: "StoreFrontModule::LineItem"

  validates :name, :address,  presence: true
  validates :name, uniqueness: true
  validates :receivable_account_id,
            :cost_of_goods_sold_account_id,
            :merchandise_inventory_account_id,
            :sales_account_id,
            :sales_return_account_id,
            :payable_account_id,
            :spoilage_account_id,
            :sales_discount_account_id,
            :internal_use_account_id,
            :purchase_return_account_id,
            presence: true,
            uniqueness: { scope: :cooperative_id }

  def self.receivable_balance(customer)
    all.map{|a| a.receivable_balance(customer) }.sum
  end


  def receivable_balance(customer)
    receivable_account.balance(commercial_document: customer)
  end
end
