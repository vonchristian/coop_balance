FactoryBot.define do
  factory :organization_member, class: 'Organizations::OrganizationMember' do
    organization
    organization_membership factory: %i[member]
  end
end
