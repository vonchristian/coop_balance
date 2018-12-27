FactoryBot.define do
  factory :organization_member, class: Organizations::OrganizationMember do
    organization_membership { nil }
    organization { nil }
  end
end
