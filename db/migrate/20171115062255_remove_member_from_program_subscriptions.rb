class RemoveMemberFromProgramSubscriptions < ActiveRecord::Migration[5.1]
  def change
    remove_reference :program_subscriptions, :member, foreign_key: true
  end
end
