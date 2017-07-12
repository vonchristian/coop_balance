FactoryGirl.define do
  factory :program_subscription, class: "MembershipsModule::ProgramSubscription" do
    program nil
    member nil
  end
end
