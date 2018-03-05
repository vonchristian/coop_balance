class RemoveMembershipFromProgramSubscriptions < ActiveRecord::Migration[5.1]
  def change
    remove_reference :program_subscriptions, :membership, foreign_key: true, type: :uuid
  end
end
