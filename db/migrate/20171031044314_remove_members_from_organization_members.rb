class RemoveMembersFromOrganizationMembers < ActiveRecord::Migration[5.1]
  def change
    remove_reference :organization_members, :member, polymorphic: true
  end
end
