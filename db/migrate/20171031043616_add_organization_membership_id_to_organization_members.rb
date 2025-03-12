class AddOrganizationMembershipIdToOrganizationMembers < ActiveRecord::Migration[5.1]
  def change
    add_reference :organization_members, :organization_membership, polymorphic: true, type: :uuid, index: { name: 'index_on_organization_members_membership' }
  end
end
