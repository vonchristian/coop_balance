class AddMembershipCategoryToMemberships < ActiveRecord::Migration[6.0]
  def change
    add_reference :memberships, :membership_category, foreign_key: true, type: :uuid 
  end
end
