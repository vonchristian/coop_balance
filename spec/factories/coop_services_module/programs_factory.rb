FactoryBot.define do
  factory :program, class: "CoopServicesModule::Program" do
    name  { Faker::Company.name}
    contribution "9.99"
    association :account, factory: :asset
  end
end
