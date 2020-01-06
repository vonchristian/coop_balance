class RemoveMembershipTypeFromMemberships < ActiveRecord::Migration[6.0]
  def change
    remove_index :memberships, :membership_type
    remove_column :memberships, :membership_type, :integer
  end
end
