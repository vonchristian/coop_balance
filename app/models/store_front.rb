class StoreFront < ApplicationRecord
  belongs_to :cooperative
  belongs_to :cost_of_goods_sold_account,    class_name: "AccountingModule::Account"
  belongs_to :merchandise_inventory_account, class_name: "AccountingModule::Account"
  belongs_to :spoilage_account,              class_name: "AccountingModule::Account"
  belongs_to :purchase_return_account,       class_name: "AccountingModule::Account"

  has_many :products,                        class_name: "StoreFrontModule::Product"
  has_many :purchase_orders,                 class_name: "StoreFrontModule::Orders::PurchaseOrder"
  has_many :purchase_line_items,                 through: :purchase_orders
  has_many :received_stock_transfers,            class_name: "StoreFrontModule::Orders::PurchaseOrder", foreign_key: "destination_store_front_id"
  has_many :delivered_stock_transfers,           class_name: "StoreFrontModule::Orders::PurchaseOrder", as: :supplier
  has_many :received_stock_transfer_line_items,  class_name: "StoreFrontModule::LineItems::PurchaseLineItem", through: :received_stock_transfers, source: :purchase_line_items
  has_many :delivered_stock_transfer_line_items, class_name: "StoreFrontModule::LineItems::PurchaseLineItem"
  has_many :orders,                              class_name: "StoreFrontModule::Order"
  has_many :line_items,                          through: :orders, class_name: "StoreFrontModule::LineItem"

  validates :name, :address, presence: true
  validates :name, uniqueness: true
end
