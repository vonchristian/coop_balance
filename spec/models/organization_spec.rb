require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe 'associations' do
    it { is_expected.to have_many :organization_members }
    it { is_expected.to have_many :member_memberships }
    it { is_expected.to have_many :employee_memberships }
    it { is_expected.to have_many :loans }
  end
  it ".members" do
    organization = create(:organization)
    member = create(:member)
    employee = create(:employee)
    organization_member = create(:organization_member, organization_membership: member, organization: organization)
    organization_member = create(:organization_member, organization_membership: employee, organization: organization)

    expect(organization.members).to include(member)
    expect(organization.members).to include(employee)
  end

end
