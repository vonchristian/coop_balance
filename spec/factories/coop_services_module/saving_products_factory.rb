FactoryBot.define do
  factory :saving_product, class: "CoopServicesModule::SavingProduct" do
    name { Faker::Name.first_name }
    interest_rate "9.99"
    interest_recurrence 1
    association :account, factory: :liability
    minimum_balance 100
  end
end
