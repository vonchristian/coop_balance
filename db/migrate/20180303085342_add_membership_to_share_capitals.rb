class AddMembershipToShareCapitals < ActiveRecord::Migration[5.1]
  def change
    add_reference :share_capitals, :membership, foreign_key: true, type: :uuid
  end
end
