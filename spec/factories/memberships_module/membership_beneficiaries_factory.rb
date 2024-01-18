FactoryBot.define do
  factory :membership_beneficiary, class: 'MembershipsModule::MembershipBeneficiary' do
    membership
    beneficary factory: %i[member]
  end
end