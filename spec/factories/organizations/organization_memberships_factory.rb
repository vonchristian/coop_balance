FactoryBot.define do
  factory :organization_member, class: Organizations::OrganizationMember do
    association :organization
    association :organization_membership, factory: :member 
  end
end
