class AddBarangayMembershipToBarangayMembers < ActiveRecord::Migration[5.2]
  def change
    add_reference :barangay_members, :barangay_membership, polymorphic: true, type: :uuid, index: { name: 'index_on_barangay_members_membership'}
  end
end
