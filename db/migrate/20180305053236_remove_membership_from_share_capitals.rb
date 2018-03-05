class RemoveMembershipFromShareCapitals < ActiveRecord::Migration[5.1]
  def change
    remove_reference :share_capitals, :membership, foreign_key: true, type: :uuid
  end
end