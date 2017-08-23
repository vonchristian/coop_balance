class AddMembershipDateToMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :membership_date, :datetime
  end
end
