FactoryBot.define do
  factory :program, class: "CoopServicesModule::Program" do
    name  { Faker::Company.name}
    amount  { 100 }
    association :account, factory: :asset
    association :cooperative
  end
end
