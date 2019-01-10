FactoryBot.define do
  factory :cooperative_service, class: CoopServicesModule::CooperativeService do
    cooperative { nil }
    title { "MyString" }
  end
end
