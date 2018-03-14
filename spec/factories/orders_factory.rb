FactoryBot.define do
  factory :order, class: "StoreFrontModule::Order" do
    association :commercial_document, factory: :member
    date "2017-06-12 13:20:12"

    factory :purchase_order, class: "StoreFrontModule::Orders::PurchaseOrder" do
      association :commercial_document, factory: :supplier
    end

    factory :sales_order, class: "StoreFrontModule::Orders::SalesOrder" do
      association :commercial_document, factory: :member
    end
  end
end
