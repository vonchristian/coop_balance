FactoryGirl.define do
  factory :order, class: "StoreModule::Order" do
    customer nil
    date "2017-06-12 13:20:12"
  end
end
