FactoryBot.define do
  factory :program_subscription, class: MembershipsModule::ProgramSubscription do
    association :program
    association :subscriber, factory: :member
    association :program_account, factory: :asset
  end
end
