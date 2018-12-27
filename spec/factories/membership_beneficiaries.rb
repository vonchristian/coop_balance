FactoryBot.define do
  factory :membership_beneficiary, class: "MembershipsModule::MembershipBeneficiary" do
    membership { nil }
    beneficiary { nil }
  end
end
