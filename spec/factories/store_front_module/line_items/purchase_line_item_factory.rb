FactoryBot.define do
  factory :purchase_line_item, class: "StoreFrontModule::LineItems::PurchaseLineItem" do
    association :product
    association :unit_of_measurement
    expiry_date Date.today.next_year
    quantity   { 1 }
    unit_cost  { 100 }
    total_cost { 100 }
  end
end
