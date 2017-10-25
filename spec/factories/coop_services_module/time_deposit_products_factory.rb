FactoryBot.define do
  factory :time_deposit_product, class: "CoopServicesModule::TimeDepositProduct" do
    minimum_amount "9.99"
    maximum_amount "9.99"
    interest_rate "9.99"
    name  { Faker::Company.catch_phrase }
  end
end
