class Supplier < ApplicationRecord
  include PgSearch
  pg_search_scope :text_search, against: [:business_name]
  has_one_attached :avatar
  has_many :addresses, as: :addressable
  has_many :entries,                class_name: "AccountingModule::Entry",
                                    as: :commercial_document
  has_many :stock_registries,       class_name: "StockRegistry"
  has_many :vouchers,               as: :payee
  has_many :voucher_amounts,        class_name: "Vouchers::VoucherAmount",
                                    as: :commercial_document
  has_many :purchase_orders,        class_name: "StoreFrontModule::Orders::PurchaseOrder",
                                    as: :commercial_document
  has_many :purchase_line_items,    class_name: "StoreFrontModule::PurchaseLineItem",
                                    through: :purchase_orders
  has_many :purchase_return_orders, class_name: "StoreFrontModule::Orders::PurchaseReturnOrder",
                                    as: :commercial_document

  validates :business_name, presence: true, uniqueness: true


  def name
    business_name
  end

  def owner_name
    [first_name, last_name].join(" ")
  end

  def balance
    deliveries_total - payments_total
  end

  def payments_total
    vouchers.disbursed.map{|a| a.payable_amount }.compact.sum
  end
end
