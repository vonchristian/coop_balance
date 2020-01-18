FactoryBot.define do 
  factory :membership_beneficiary, class: MembershipsModule::MembershipBeneficiary do 
    association :membership 
    association :beneficary, factory: :member
  end 
end 