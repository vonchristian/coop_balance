class RemoveMembershipDateFromMembers < ActiveRecord::Migration[5.1]
  def change
    remove_column :members, :membership_date, :datetime
  end
end
