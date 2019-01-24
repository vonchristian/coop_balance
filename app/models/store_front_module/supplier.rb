module StoreFrontModule
  class Supplier < ApplicationRecord
    include PgSearch
    pg_search_scope :text_search, against: [:business_name]
    has_one_attached :avatar
    belongs_to :cooperative
    belongs_to :payable_account, class_name: "AccountingModule::Account"
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

    before_save :set_default_image, on: :create

    def name
      business_name
    end

    def owner_name
      "#{first_name} #{last_name}"
    end

    private
    def set_default_image
      if !avatar.attached?
        self.avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'default.png')), filename: 'default-image.png', content_type: 'image/png')
      end
    end
  end
end