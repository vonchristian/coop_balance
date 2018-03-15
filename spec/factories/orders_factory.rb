FactoryBot.define do
  factory :order, class: "StoreFrontModule::Order" do
    association :commercial_document, factory: :member
    date "2017-06-12 13:20:12"

    factory :purchase_order, class: "StoreFrontModule::Orders::PurchaseOrder" do
      association :commercial_document, factory: :supplier
    end
    factory :purchase_return_order, class: "StoreFrontModule::Orders::PurchaseReturnOrder" do
      association :commercial_document, factory: :supplier
    end

    factory :sales_order, class: "StoreFrontModule::Orders::SalesOrder" do
      association :commercial_document, factory: :member
    end
    factory :sales_return_order, class: "StoreFrontModule::Orders::SalesReturnOrder" do
      association :commercial_document, factory: :member
    end
    factory :internal_use_order, class: "StoreFrontModule::Orders::InternalUseOrder" do
      association :commercial_document, factory: :user
    end
    factory :stock_transfer_order, class: "StoreFrontModule::Orders::StockTransferOrder" do
      association :commercial_document, factory: :store_front
    end

    factory :received_stock_transfer_order, class: "StoreFrontModule::Orders::ReceivedStockTransferOrder" do
      association :commercial_document, factory: :store_front
    end
  end
end
