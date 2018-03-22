class Supplier < ApplicationRecord
  include PgSearch
  pg_search_scope :text_search, against: [:business_name]
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

  has_attached_file :avatar,
  styles: { large: "120x120>",
           medium: "70x70>",
           thumb: "40x40>",
           small: "30x30>",
           x_small: "20x20>"},
  default_url: ":style/profile_default.jpg",
  :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
  :url => "/system/:attachment/:id/:style/:filename"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

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

  def deliveries_total
    CoopConfigurationsModule::StoreFrontConfig.default_accounts_payable_account.balance(commercial_document_id: self.id)
  end
end
