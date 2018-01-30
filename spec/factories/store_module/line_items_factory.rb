FactoryBot.define do
  factory :line_item, class: "StoreFrontModule::LineItem" do
    association :line_itemable, factory: :product_stock
    unit_cost "9.99"
    total_cost "9.99"
    date "2017-06-12 13:15:14"
  end
end
