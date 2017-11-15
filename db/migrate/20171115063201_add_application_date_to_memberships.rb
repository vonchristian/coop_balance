class AddApplicationDateToMemberships < ActiveRecord::Migration[5.1]
  def change
    add_column :memberships, :application_date, :datetime
    add_column :memberships, :approval_date, :datetime
  end
end
