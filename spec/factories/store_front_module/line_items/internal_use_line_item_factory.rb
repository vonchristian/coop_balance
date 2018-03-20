FactoryBot.define do
  factory :internal_use_line_item, class: "StoreFrontModule::LineItems::InternalUseLineItem" do
    association :product
    association :unit_of_measurement
    association :purchase_line_item
  end
end

