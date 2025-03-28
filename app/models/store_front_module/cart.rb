module StoreFrontModule
  class Cart < ApplicationRecord
    belongs_to :customer, polymorphic: true, optional: true
    has_many :voucher_amounts, class_name: "Vouchers::VoucherAmount", dependent: :destroy
    has_many :cash_counts
    has_many :share_capitals, class_name: "DepositsModule::ShareCapital", dependent: :destroy # for merging

    has_many :members, dependent: :destroy # for merging
    belongs_to :employee,                         class_name: "User", foreign_key: "user_id"
    has_many :line_items,                         class_name: "StoreFrontModule::LineItem",
                                                  dependent: :destroy
    has_many :purchase_line_items,                class_name: "StoreFrontModule::LineItems::PurchaseLineItem",
                                                  dependent: :destroy
    has_many :sales_line_items,                   class_name: "StoreFrontModule::LineItems::SalesLineItem",
                                                  dependent: :destroy
    has_many :spoilage_line_items,                class_name: "StoreFrontModule::LineItems::SpoilageLineItem",
                                                  dependent: :destroy
    has_many :sales_return_line_items,            class_name: "StoreFrontModule::LineItems::SalesReturnLineItem",
                                                  dependent: :destroy
    has_many :purchase_return_line_items,         class_name: "StoreFrontModule::LineItems::PurchaseReturnLineItem",
                                                  dependent: :destroy
    has_many :internal_use_line_items,            class_name: "StoreFrontModule::LineItems::InternalUseLineItem",
                                                  dependent: :destroy
    has_many :stock_transfer_line_items,          class_name: "StoreFrontModule::LineItems::PurchaseReturnLineItem",
                                                  dependent: :destroy
    has_many :received_stock_transfer_line_items, class_name: "StoreFrontModule::LineItems::PurchaseReturnLineItem",
                                                  dependent: :destroy
    def total_cost
      line_items.sum(&:total_cost)
    end
  end
end
