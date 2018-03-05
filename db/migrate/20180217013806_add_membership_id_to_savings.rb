class AddMembershipIdToSavings < ActiveRecord::Migration[5.1]
  def change
    add_reference :savings, :membership, foreign_key: true, type: :uuid
  end
end