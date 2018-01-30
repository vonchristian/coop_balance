FactoryBot.define do
  factory :order, class: "StoreFrontModule::Order" do
    association :customer, factory: :member
    date "2017-06-12 13:20:12"
  end
end
