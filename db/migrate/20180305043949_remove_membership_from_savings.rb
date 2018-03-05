class RemoveMembershipFromSavings < ActiveRecord::Migration[5.2]
  def change
    remove_reference :savings, :membership, foreign_key: true, type: :uuid
  end
end
