require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe 'associations' do
    it { should have_many :organization_members }
    it { should have_many :member_memberships }
    it { should have_many :employee_memberships }
    it { should have_many :loans }
    it { should have_many :savings }
    it { should have_many :time_deposits }
    it { should have_many :share_capitals }
    it { should have_many :addresses }
  end

  it '.members' do
    organization = create(:organization)
    member       = create(:member)
    employee     = create(:employee)
    create(:organization_member, organization_membership: member,   organization: organization)
    create(:organization_member, organization_membership: employee, organization: organization)

    expect(organization.members).to include(member)
    expect(organization.members).to include(employee)
  end

  it '#signatory_name' do
    organization = build(:organization)
    expect(organization.signatory_name).to eq organization.name
  end
end
