class AddMemberTypeToOrganizationMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :organization_members, :member_type, :string
    add_index :organization_members, :member_type
  end
end
