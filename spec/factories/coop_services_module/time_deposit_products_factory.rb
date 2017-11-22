FactoryBot.define do
  factory :time_deposit_product, class: "CoopServicesModule::TimeDepositProduct" do
    minimum_amount "9.99"
    maximum_amount "9.99"
    interest_rate "9.99"
    time_deposit_product_type 'for_member'
    name  { Faker::Company.catch_phrase }
    association :account, factory: :liability
  end
end
