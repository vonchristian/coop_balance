class RemoveMemberableFromMemberships < ActiveRecord::Migration[5.1]
  def change
    remove_reference :memberships, :memberable, polymorphic: true, type: :uuid
  end
end
