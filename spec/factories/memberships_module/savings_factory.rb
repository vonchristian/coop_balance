FactoryBot.define do
  factory :saving, class: MembershipsModule::Saving do
    association :depositor, factory: :member
  end
end
