class AddStatusToMemberships < ActiveRecord::Migration[5.2]
  def change
    add_column :memberships, :status, :integer
    add_index :memberships, :status
  end
end
