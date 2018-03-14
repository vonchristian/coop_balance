FactoryBot.define do
  factory :purchase_line_item, class: "StoreFrontModule::LineItems::PurchaseLineItem" do
    association :product
    association :unit_of_measurement
  end
end

