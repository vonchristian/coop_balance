class RemoveMembershipFromShareCapitals < ActiveRecord::Migration[5.2]
  def change
    remove_reference :share_capitals, :membership, foreign_key: true, type: :uuid
  end
end
